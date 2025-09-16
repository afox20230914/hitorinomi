class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "ログインしました"
    else
      flash.now[:alert] = "メールアドレスかパスワードが間違っています。"
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: 'ログアウトしました'
  end

  if @user && @user.authenticate(params[:password])
    if @user.is_deleted
      flash[:alert] = "このアカウントは退会済みです。"
      render :new
    else
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    end
  end
end