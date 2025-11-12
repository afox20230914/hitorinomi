class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def require_login
    return if logged_in?

    respond_to do |f|
      f.json { render json: { error: 'login_required' }, status: :unauthorized }
      f.html { redirect_to login_path, alert: 'ログインしてください' }
    end
  end
end

