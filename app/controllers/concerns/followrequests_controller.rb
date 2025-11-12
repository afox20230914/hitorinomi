class FollowRequestsController < ApplicationController
  before_action :require_login

  def create
    followed = User.find(params[:followed_id])

    # すでに申請済みならスキップ
    unless Notification.exists?(user: followed, actor: current_user, category: :follow_request)
      Notification.create!(
        user: followed,
        actor: current_user,
        category: :follow_request,
        message: "#{current_user.username}さんからフォロー申請がありました",
        read: false
      )
    end

    flash[:notice] = "フォロー申請を送信しました"
    redirect_to user_path(followed)
  end
end
