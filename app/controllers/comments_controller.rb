class CommentsController < ApplicationController
  def create
    @store = Store.find(params[:store_id])
    @comment = @store.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to store_path(@store), notice: "コメントを投稿しました"
    else
      render "stores/show"
    end
  end

  def good
    comment = Comment.find(params[:id])
    comment.increment!(:good_count)
    redirect_back fallback_location: root_path
  end

  def bad
    comment = Comment.find(params[:id])
    comment.increment!(:bad_count)
    redirect_back fallback_location: root_path
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
