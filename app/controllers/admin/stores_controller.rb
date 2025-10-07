module Admin
  class StoresController < Admin::BaseController
    before_action :authenticate_admin
    layout 'admin'

    # 一覧
    def index
      @stores = ::Store.all.order(created_at: :desc)
    end

    # 詳細
    def show
      @store = ::Store.find(params[:id])
    end

    # 削除
    def destroy
      store = ::Store.find(params[:id])
      store.destroy
      redirect_to admin_stores_path, notice: "店舗を削除しました"
    end

    private

    def authenticate_admin
      redirect_to admin_login_path unless session[:admin_id]
    end
  end
end
