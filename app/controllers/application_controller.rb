class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  private

  def authenticate_user!
    unless current_user
      # 元のURLを保持
      session[:return_to] = request.fullpath
      flash[:alert] = "ログインしてください"
      redirect_to login_path
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      flash[:alert] = "ログインしてください"
      redirect_to login_path
    end
  end
end
