class ReportsController < ApplicationController
  def new
    @comment = Comment.find(params[:comment_id])
  end

  def create
    # 実際の保存処理は後で追加
    redirect_to store_path(params[:store_id]), notice: "報告を受け付けました。"
  end
end