class Admin::BaseController < ApplicationController
  layout "admin"  # ← これ必須！
  before_action :authenticate_admin

  private

  def authenticate_admin
    redirect_to admin_login_path unless session[:admin_id]
  end
end
