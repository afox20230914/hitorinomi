class UsersController < ApplicationController
  before_action :authenticate_user!, only: [ :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user), notice: "登録が完了しました"
    else
      Rails.logger.info "NEW RENDER ERRORS: #{@user.errors.full_messages.inspect}"
      render :new
    end
  end

  def show
    @user = User.find(params[:id])

    @most_visited_store = Store.joins(:visits)
      .where(visits: { user_id: @user.id })
      .group('stores.id')
      .order('COUNT(visits.id) DESC')
      .first

    @favorite_stores = @user.favorite_stores.order(created_at: :desc)
  end

  def edit
    @user = User.find(params[:id])
    # 本人以外のアクセスはトップへ
    redirect_to root_path unless current_user == @user
  end
  
  def update
    @user = User.find(params[:id])
    redirect_to root_path and return unless current_user == @user
  
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "登録情報を更新しました"
    else
      render :edit
    end
  end
  
  

  def comments
    @user = User.find(params[:id])
    @comments = @user.comments
  end

  def applications
    @user = User.find(params[:id])
    @applications = @user.applications
  end

  def followers
    load_follow_lists
    @tab = :followers            # ← どっちのタブかを明示
    render :follows              # ← ビューは1枚に統一
  end

  def follows
    load_follow_lists
    @tab = :following            # ← どっちのタブかを明示
  end

  def unfollow
    user = User.find(params[:id])
    current_user.following.destroy(user)
    redirect_to user_path(user), notice: "フォローを解除しました。"
  end
  
  
  


  # --- 退会確認ページ ---
  def withdraw
    @user = User.find(params[:id])
  end

  # --- 退会実行処理 ---
  def deactivate
    @user = User.find(params[:id])
    if @user.update(is_deleted: true)
      reset_session
      redirect_to complete_withdraw_user_path(@user)
    else
      render :withdraw
    end
  end

  # --- 退会完了ページ ---
  def complete_withdraw
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

  def load_follow_lists
    @user       = User.find(params[:id])
    @followers  = @user.followers
    @following  = @user.following
  end
end
