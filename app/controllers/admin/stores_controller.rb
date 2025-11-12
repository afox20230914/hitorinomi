module Admin
  class StoresController < Admin::BaseController
    before_action :authenticate_admin
    layout 'admin'
    
    def index
      @stores = ::Store.all.order(created_at: :desc)
    end

    def edit
      @store = Store.find(params[:id])
    end

    # 詳細
    def show
      @store = ::Store.find(params[:id])
      @post  = @store.respond_to?(:post) ? @store.post : nil

      # 画像（Store→Post の順でフォールバック）
      store_images = []
      %i[main_image_1 main_image_2 main_image_3 main_image_4].each do |name|
        att = @store.public_send(name) rescue nil
        store_images << att if att && att.respond_to?(:attached?) && att.attached?
      end

      post_images = []
      if @post && @post.respond_to?(:main_image_1)
        %i[main_image_1 main_image_2 main_image_3 main_image_4].each do |name|
          att = @post.public_send(name) rescue nil
          post_images << att if att && att.respond_to?(:attached?) && att.attached?
        end
      end

      all_images   = store_images.presence || post_images.presence || []
      @main_image  = all_images.first
      @sub_images  = all_images.drop(1) # 常に配列
      @all_images  = all_images

      # 住所（Store→Post）
      @address = [
        (@store&.postal_code.presence  || @post&.postal_code).presence,
        (@store&.prefecture.presence   || @post&.prefecture).presence,
        (@store&.city.presence         || @post&.city).presence,
        (@store&.address_detail.presence || @post&.address_detail).presence
      ].compact.join(' ')

      # 基本情報（Store→Post）
      @store_name  = @store&.name.presence || @post&.name.presence
      @store_type  = @store&.store_type.presence || @post&.store_type.presence
      @smoking     = @store&.smoking_allowed.presence || @post&.smoking_allowed.presence
      @description = @store&.description.presence || @post&.description.presence

      # 営業時間
      @opening_time = @store&.opening_time
      @closing_time = @store&.closing_time

      # 定休日（配列/文字列どちらでも）
      @holidays =
        if @store&.holidays.present?
          @store.holidays.is_a?(Array) ? @store.holidays.join(' / ') : @store.holidays
        elsif @post&.holidays.present?
          @post.holidays.is_a?(Array) ? @post.holidays.join(' / ') : @post.holidays
        end

      # 予算（Store→Post(budget→budget_range)）
      raw_budget = @store&.budget.presence || @post&.budget.presence || @post&.budget_range.presence
      @budget_text =
        if raw_budget.is_a?(Numeric)
          ActionController::Base.helpers.number_to_currency(raw_budget, unit: "¥", precision: 0)
        elsif raw_budget.present?
          raw_budget.to_s
        else
          nil
        end
    end

    # 削除
    def destroy
      store = ::Store.find(params[:id])
      store.destroy
      redirect_to admin_stores_path, notice: "店舗を削除しました"
    end

    private

    def authenticate_admin
      redirect_to admin_login_path unless session[:admin_id]
    end
  end
end
