class SearchesController < ApplicationController
  def index
    @keyword = params[:keyword]
    @category = params[:category] || "store"

    case @category
    when "store"
      @results = Store.where("name LIKE ?", "%#{@keyword}%")
    when "tag"
      @results = Tag.where("name LIKE ?", "%#{@keyword}%")
    when "user"
      @results = User.where("username LIKE ?", "%#{@keyword}%")
    when "comment"
      @results = Comment.where("body LIKE ?", "%#{@keyword}%")
    else
      @results = []
    end
  end
end
