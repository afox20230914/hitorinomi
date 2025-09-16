class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user), notice: "登録が完了しました"
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  
    # 来店履歴から「一番行く店」を抽出
    @most_visited_store = Store.joins(:visits)
    .where(visits: { user_id: @user.id })
    .group('stores.id')
    .order('COUNT(visits.id) DESC')
    .first

  
    @favorite_stores = @user.favorite_stores.order(created_at: :desc)
  end
  

  def visits
    @user = User.find(params[:id])
    @visits = @user.visits.includes(:store)
  end

  def favorite_stores
    @user = User.find(params[:id])
    @favorite_stores = @user.favorite_stores.order(created_at: :desc)
  end
  

  def comments
    @user = User.find(params[:id])
    @comments = @user.comments
  end

  def applications
    @user = User.find(params[:id])
    @applications = @user.applications
  end

  def withdraw
    @user = User.find(params[:id])
  end

  def deactivate
    @user = User.find(params[:id])
    if @user.update(is_deleted: true)
      reset_session
      redirect_to root_path, notice: "退会処理が完了しました。ご利用ありがとうございました。"
    else
      flash[:alert] = "退会処理に失敗しました。"
      render :withdraw
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :last_name,
      :first_name,
      :phone_number,
      :birth_date,
      :username,
      :profile,
      :icon
    )
  end
end
