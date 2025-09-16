class VisitsController < ApplicationController
  before_action :require_login

  def create
    store = Store.find(params[:id])
    current_user.visits.create!(store: store)

    flash[:notice] = "来店記録を登録しました"
    redirect_to store_path(store)
  end
end

