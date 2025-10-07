module Admin
  class CommentsController < Admin::BaseController
    before_action :authenticate_admin
    layout 'admin'

    # 一覧
    def index
      @comments = ::Comment.all.order(created_at: :desc)
    end

    # 削除
    def destroy
      comment = ::Comment.find(params[:id])
      comment.destroy
      redirect_to admin_comments_path, notice: "コメントを削除しました"
    end

    private

    def authenticate_admin
      redirect_to admin_login_path unless session[:admin_id]
    end
  end
end
