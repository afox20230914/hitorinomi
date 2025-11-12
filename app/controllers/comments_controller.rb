class CommentsController < ApplicationController
  before_action :require_login, only: %i[create good bad]
  before_action :set_store, only: %i[create good bad]
  before_action :set_comment, only: %i[good bad]

  # コメント新規投稿
  def create
    @comment = @store.comments.build(comment_params)
    @comment.user = current_user

    unless current_user.visited_stores.include?(@store)
      flash[:alert] = "来店履歴があるユーザーのみコメントできます。"
      redirect_to store_path(@store) and return
    end

    if @comment.save
      flash[:notice] = "コメントを投稿しました。"
      redirect_to store_path(@store)
    else
      flash[:alert] = "コメントの投稿に失敗しました。"
      redirect_to store_path(@store)
    end
  end

  # GOOD評価
  def good
    vote!("good")
  end

  # BAD評価
  def bad
    vote!("bad")
  end

  private

  def set_store
    @store = Store.find(params[:store_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:title, :body)
  end

  # 評価処理
  def vote!(type)
    result = nil
    @comment.with_lock do
      existing = current_user.votes.find_by(comment: @comment)

      if existing&.vote_type == type
        existing.destroy!
        status = "removed"
        message = "#{type.upcase}を取り消しました。"
      else
        if existing
          existing.update!(vote_type: type)
          status = "changed"
          message = "評価を変更しました。"
        else
          current_user.votes.create!(comment: @comment, vote_type: type)
          status = "added"
          message = "#{type.upcase}しました。"
        end
      end

      result = {
        good_count: @comment.votes.where(vote_type: 'good').count,
        bad_count:  @comment.votes.where(vote_type: 'bad').count,
        status: status,
        message: message
      }
    end

    render json: result
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end
end

