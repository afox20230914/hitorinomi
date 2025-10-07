class FavoritesController < ApplicationController
  before_action :require_login

  def create
    store = Store.find(params[:id])
    current_user.favorites.create(store: store)
    flash[:notice] = "お気に入りに登録しました！🍶"
    redirect_to store_path(store)
  end

  def destroy
    store = Store.find(params[:id])
    favorite = current_user.favorites.find_by(store: store)
    favorite&.destroy
    flash[:notice] = "お気に入りを解除しました。"
    redirect_to store_path(store)
  end

  private

  def require_login
    redirect_to login_path unless current_user
  end
end
