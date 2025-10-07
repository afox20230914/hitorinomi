module Admin
  class ContactsController < Admin::BaseController
    before_action :authenticate_admin
    layout 'admin'

    # 一覧
    def index
      @contacts = ::Contact.order(created_at: :desc)
    end

    # 詳細
    def show
      @contact = ::Contact.find(params[:id])
    end

    # 削除
    def destroy
      contact = ::Contact.find(params[:id])
      contact.destroy
      redirect_to admin_contacts_path, notice: "お問い合わせを削除しました"
    end

    private

    def authenticate_admin
      redirect_to admin_login_path unless session[:admin_id]
    end
  end
end
