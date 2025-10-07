class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all

    # 検索処理
    if params[:keyword].present?
      @users = @users.where("username LIKE ?", "%#{params[:keyword]}%")
    end

    # ソート処理
    sort = params[:sort] || "name"
    direction = params[:direction] || "asc"

    case sort
    when "name"
      @users = @users.order(username: direction)
    when "date"
      @users = @users.order(created_at: direction)
    else
      @users = @users.order(created_at: :asc)
    end
  end
end





