# frozen_string_literal: true

class PostsController < ApplicationController
  def new
    if session[:post_data].is_a?(Integer)
      @post = Post.find(session[:post_data])
    else
      @post = Post.new(session[:post_data] || {})
    end
    @post.build_store if @post.store.nil?
  end

  def confirm
    safe = post_params_all.to_h
    safe.delete(:opening_hours)       # 仮想フィールド
    safe.delete(:sub_images_category) # 仮想フィールド
    safe.delete(:building_name)       # Postにカラムなし

    # 営業時間テキスト（そのまま保存）
    safe[:hours_text] = params.dig(:post, :hours_text).to_s

    @post = Post.new(safe)
    @post.save(validate: false)
    session[:post_data] = @post.id

    # サブ画像：表示用グルーピング
    cats = Array(params.dig(:post, :sub_images_category))
    subs = @post.sub_images.attachments
    @preview_groups = { exterior_images: [], interior_images: [], food_images: [], menu_images: [] }
    subs.each_with_index do |att, idx|
      key = cats[idx].to_s.presence&.to_sym
      @preview_groups[key] << att if key && @preview_groups.key?(key)
    end

    # 営業時間（表示用のみ：旧テーブル形式サポート）
    @hours_data, @irregular_holiday = build_hours_data(params)

    render :confirm
  end

  def create
    @post = Post.find(session[:post_data])

    # サブ画像：本カテゴリへ移行
    cats = Array(params.dig(:post, :sub_images_category))
    @post.sub_images.attachments.each_with_index do |att, idx|
      cat = cats[idx].to_s
      next if cat.blank?
      blob = att.blob
      case cat
      when 'exterior_images' then @post.exterior_images.attach(blob)
      when 'interior_images' then @post.interior_images.attach(blob)
      when 'food_images'     then @post.food_images.attach(blob)
      when 'menu_images'     then @post.menu_images.attach(blob)
      end
      att.purge
    end

    # ===== Store作成（公開） =====
    @store = Store.create!(
      name:             @post.name,
      postal_code:      @post.postal_code,
      prefecture:       @post.prefecture,
      city:             @post.city,
      address_detail:   @post.address_detail,
      opening_time:     nil,
      closing_time:     nil,
      seating_capacity: @post.seating_capacity,
      store_type:       @post.store_type,
      smoking_allowed:  @post.smoking_allowed,
      holidays:         "",
      budget:           @post.budget,
      description:      @post.description,
      user_id:          current_user&.id,
      is_owner:         @post.is_owner,
      post_id:          @post.id,
      hours_text:       @post.hours_text # ← そのままコピー
    )

    # 画像コピー（Post の blob を Store の添付にコピー）
    main_slots = %i[main_image_1 main_image_2 main_image_3 main_image_4]
    @post.main_images.attachments.each_with_index do |attachment, i|
      blob = attachment.blob
      next unless blob && main_slots[i]
      begin
        @store.public_send(main_slots[i]).attach(blob)
      rescue => e
        Rails.logger.error("[PostsController#create] failed to attach main image ##{i}: #{e.message}")
      end
    end

    # 旧テーブル形式の営業時間・定休日（必要なら保存）
    hours_payload = hours_payload_from_params(params)
    @store.update!(hours_payload) if hours_payload.present?

    # Postの更新（画像以外）
    if @post.update(post_params_without_files)
      session.delete(:post_data)
      redirect_to store_path(@store), notice: '店舗を公開しました。'
    else
      # 確認画面に必要なデータ再構築
      cats = Array(params.dig(:post, :sub_images_category))
      @preview_groups = { exterior_images: [], interior_images: [], food_images: [], menu_images: [] }
      @post.sub_images.attachments.each_with_index do |att, idx|
        key = cats[idx].to_s.presence&.to_sym
        @preview_groups[key] << att if key && @preview_groups.key?(key)
      end
      @hours_data, @irregular_holiday = build_hours_data(params)
      render :confirm
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  # 営業時間のDB保存用ペイロード（confirm と同等判定）
  def hours_payload_from_params(params)
    post_hash = params[:post] || {}
    hours = post_hash[:opening_hours].presence || post_hash['opening_hours'].presence || {}
    irregular = false
    irregular ||= (hours['irregular'].to_s == '1') if hours.is_a?(Hash)
    irregular ||= post_hash['irregular_holiday'].to_s == '1'
    irregular ||= post_hash[:irregular_holiday].to_s == '1'

    days = %w[月 火 水 木 金 土 日 祝]
    rows = []
    if hours.present?
      days.each do |d|
        rows << {
          day:     d,
          open1:   str4(hours["#{d}_open1"]),
          close1:  str4(hours["#{d}_close1"]),
          open2:   str4(hours["#{d}_open2"]),
          close2:  str4(hours["#{d}_close2"]),
          holiday: (hours["#{d}_holiday"].to_s == '1')
        }
      end
    end

    ot = ct = nil
    if rows.any?
      regular = rows.reject { |r| r[:holiday] }
      if regular.any?
        regular.each do |r|
          if r[:open1].present? && r[:close1].present?
            ot = hhmm(r[:open1]); ct = hhmm(r[:close1]); break
          elsif r[:open2].present? && r[:close2].present?
            ot = hhmm(r[:open2]); ct = hhmm(r[:close2]); break
          end
        end
      end
    end

    if ot.blank? && (post_hash['opening_time'].present? || post_hash[:opening_time].present?)
      ot = post_hash['opening_time'].presence || post_hash[:opening_time].presence
    end
    if ct.blank? && (post_hash['closing_time'].present? || post_hash[:closing_time].present?)
      ct = post_hash['closing_time'].presence || post_hash[:closing_time].presence
    end

    holiday_days = []
    if rows.any?
      holiday_days = rows.select { |r| r[:holiday] }.map { |r| r[:day] }
    end
    flat_holidays = post_hash['holidays'].presence || post_hash[:holidays].presence
    holidays_str = if holiday_days.any?
                     holiday_days.join('・')
                   elsif flat_holidays.present?
                     flat_holidays.to_s
                   else
                     ""
                   end

    payload = {
      opening_time:      (ot.presence || nil),
      closing_time:      (ct.presence || nil),
      irregular_holiday: irregular,
      holidays:          holidays_str
    }

    if payload.values_at(:opening_time, :closing_time, :irregular_holiday, :holidays).all? { |v| v.blank? || v == false }
      {}
    else
      payload
    end
  end

  # "1100" / "11:00" / "11-00" 等を4桁数字に正規化
  def str4(v)
    s = v.to_s.gsub(/\D/, "")[0,4]
    s.present? ? s.rjust(4, "0") : nil
  end

  # "HHMM" -> "HH:MM"
  def hhmm(s4)
    return nil if s4.blank?
    s = s4.to_s.rjust(4, "0")
    "#{s[0,2]}:#{s[2,2]}"
  end

  # 確認画面用：画像含む（hours_text を含める）
  def post_params_all
    params.require(:post).permit(
      :name, :postal_code, :prefecture, :city, :address_detail,
      :opening_time, :closing_time, :seating_capacity, :store_type,
      :smoking_allowed, :holidays, :budget, :description, :is_owner,
      :status, :contact_info, :building_name, :hours_text,
      main_images: [], sub_images: [], sub_images_category: [],
      exterior_images: [], interior_images: [], food_images: [], menu_images: [],
      opening_hours: {},
      store_attributes: [
        :postal_code, :prefecture, :city, :address_detail, :opening_time,
        :closing_time, :seating_capacity, :store_type, :smoking_allowed,
        :holidays, :budget, :description, :is_owner
      ]
    )
  end

  # 登録用：画像以外（hours_text を含める）
  def post_params_without_files
    params.require(:post).permit(
      :name, :postal_code, :prefecture, :city, :address_detail,
      :opening_time, :closing_time, :seating_capacity, :store_type,
      :smoking_allowed, :holidays, :budget, :description, :is_owner,
      :status, :contact_info, :hours_text,
      store_attributes: [
        :postal_code, :prefecture, :city, :address_detail, :opening_time,
        :closing_time, :seating_capacity, :store_type, :smoking_allowed,
        :holidays, :budget, :description, :is_owner
      ]
    )
  end

  # 確認画面の表示用データ（保存しない）
  # 戻り値: [hours_data(Array<Hash>), irregular_holiday(Boolean)]
  def build_hours_data(params)
    hours = params.dig(:post, :opening_hours) || {}
    days = %w[月 火 水 木 金 土 日 祝]
    data = days.map do |d|
      {
        day:     d,
        open1:   hours["#{d}_open1"].presence,
        close1:  hours["#{d}_close1"].presence,
        open2:   hours["#{d}_open2"].presence,
        close2:  hours["#{d}_close2"].presence,
        holiday: hours["#{d}_holiday"].to_s == "1"
      }
    end
    irregular = (hours["irregular"].to_s == "1") || params.dig(:post, :irregular_holiday).to_s == "1"
    [data, irregular]
  end
end
