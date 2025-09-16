class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
  end

  def confirm
    @post = Post.new(post_params)
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to user_path(current_user), notice: "申請が完了しました"
    else
      flash[:alert] = "エラーがあります"
      render :confirm
    end
  end

  def complete
    @post = Post.new(post_params)
    if @post.save
      redirect_to user_path(current_user), notice: "申請が完了しました"
    else
      render :new
    end
  end

  private

  def post_params
    params.require(:post).permit(
      :name,
      :postal_code,
      :prefecture,
      :city,
      :address_detail,
      :opening_time,
      :closing_time,
      :seating_capacity,
      :store_type,
      :smoking_allowed,
      :holidays,
      :budget,
      :description,
      :is_owner,
      images: []
    )
  end
end
