class Admin::DashboardController < Admin::BaseController
  def index
    @contacts = Contact.order(created_at: :desc).limit(20)
    @new_store_applications = Post.where(status: "pending").order(created_at: :desc).limit(20)
    @store_corrections = Post.where(status: "correction").order(created_at: :desc).limit(20)

    @timeline = (
      @contacts.map { |c|
        OpenStruct.new(
          kind: :contact,
          title: "お問い合わせがありました",
          snippet: c.try(:content).presence || c.try(:body).to_s,
          created_at: c.created_at
        )
      } +
      @new_store_applications.map { |p|
        OpenStruct.new(
          kind: :new_store,
          title: "新規店舗申請がありました",
          store_name: p.try(:store_name) || p.try(:title) || "店舗名",
          created_at: p.created_at
        )
      } +
      @store_corrections.map { |p|
        OpenStruct.new(
          kind: :correction,
          title: "店舗情報修正依頼がありました",
          store_name: p.try(:store_name) || p.try(:title) || "店舗名",
          created_at: p.created_at
        )
      }
    ).sort_by(&:created_at).reverse
  end
end


