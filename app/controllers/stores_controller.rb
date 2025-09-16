class StoresController < ApplicationController
  def index
    @stores = Post.all.order(created_at: :desc)
  end

  def show
    @store = Store.find(params[:id])
  end

  def interior_images
    @store = Store.find(params[:id])
  end
end