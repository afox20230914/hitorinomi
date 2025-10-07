class SessionsController < ApplicationController
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(email: params[:email]) # 入力値保持用
    user = User.find_by(email: params[:email])
  
    if user&.authenticate(params[:password])
      if user.is_deleted
        flash.now[:alert] = "このアカウントは退会済みです。"
        render :new, status: :unprocessable_entity
      else
        session[:user_id] = user.id
        flash[:notice] = "ログインしました"
  
        # ✅ 元のページに戻る or マイページへ
        redirect_to(session.delete(:return_to) || user_path(user))
      end
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが間違っています。"
      render :new, status: :unprocessable_entity
    end
  end
 
  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: 'ログアウトしました'
  end
end
