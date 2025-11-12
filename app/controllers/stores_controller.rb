# app/controllers/stores_controller.rb
class StoresController < ApplicationController
  def index
    @stores = Store.published.order(created_at: :desc)
  end

  def show
    @store = Store.find(params[:id])

    # コメント・投票情報（既存機能は保持）
    @comments = @store.comments.order(created_at: :desc).limit(10)
    if current_user
      @user_votes = current_user.votes.where(comment_id: @comments.pluck(:id))
                                      .pluck(:comment_id, :vote_type)
                                      .to_h
    else
      @user_votes = {}
    end
    @can_comment = logged_in? && Visit.exists?(user_id: current_user.id, store_id: @store.id)
    @comment = Comment.new

    # ==== 営業時間・定休日（Store列のみ使用） ====
    @opening_time = time_hhmm(@store.opening_time)
    @closing_time = time_hhmm(@store.closing_time)
    @irregular_holiday = !!@store.irregular_holiday
    @holidays = @store.holidays.presence || "未設定"
  end

  private

  # "1100" / 1100 / "11:00" / Time / nil → "11:00" or nil
  def time_hhmm(val)
    return nil if val.nil?
    s = val.is_a?(Time) || val.is_a?(ActiveSupport::TimeWithZone) ? val.strftime("%H%M") : val.to_s
    s = s.gsub(/\D/, "")[0,4]
    return nil if s.blank?
    s = s.rjust(4, "0")
    "#{s[0,2]}:#{s[2,2]}"
  end
end
