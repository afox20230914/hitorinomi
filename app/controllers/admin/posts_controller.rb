module Admin
  class PostsController < Admin::BaseController
    before_action :authenticate_admin
    layout 'admin'

    def index
      @posts = ::Post.order(created_at: :desc)
    end

    def show
      @post = ::Post.find(params[:id])
    end

    def destroy
      post = ::Post.find(params[:id])
      post.destroy
      redirect_to admin_posts_path, notice: "投稿を削除しました"
    end

    private

    def authenticate_admin
      redirect_to admin_login_path unless session[:admin_id]
    end
  end
end
