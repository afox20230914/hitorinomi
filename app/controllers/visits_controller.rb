class VisitsController < ApplicationController
  before_action :require_login

  def create
    store = Store.find(params[:store_id])

    # ✅ 直近1時間以内の重複クリック防止
    recent_visit = current_user.visits
                      .where(store: store)
                      .where('created_at >= ?', 1.hour.ago)
                      .exists?

    if recent_visit
      flash[:alert] = "1時間以内に同じ店舗で来店ボタンを押すことはできません。"
    else
      current_user.visits.create!(store: store)
      flash[:notice] = "来店を記録しました！らっしゃい！🍶"
    end

    redirect_to store_path(store)
  end

  private

  def require_login
    redirect_to login_path unless current_user
  end
end


