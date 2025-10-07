module Admin
  class SessionsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create]
    layout 'admin_login', only: [:new]  # ← これを追加！！

    def new
    end

    def create
      admin = ::Administrator.find_by(email: params[:email])  # ← ← モジュール衝突を避ける
      if admin&.authenticate(params[:password])
        session[:admin_id] = admin.id
        redirect_to admin_root_path, notice: "ログインしました" 
      else
        flash.now[:alert] = 'メールアドレスまたはパスワードが違います。'
        render :new
      end
    end

    def destroy
      session.delete(:admin_id)
      redirect_to admin_login_path, notice: 'ログアウトしました。'
    end
  end
end
