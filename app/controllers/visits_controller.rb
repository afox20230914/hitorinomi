class VisitsController < ApplicationController
  before_action :require_login

  def create
    store = Store.find(params[:id])
    current_user.visits.create(store: store)
    flash[:notice] = "来店を記録しました！らっしゃい！🍶"
    redirect_to store_path(store)
  end

  private

  def require_login
    redirect_to login_path unless current_user
  end
end


