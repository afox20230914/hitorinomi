# app/controllers/notifications_controller.rb
class NotificationsController < ApplicationController
  before_action :require_login

  # 通知一覧
  def index
    @notifications = current_user.notifications.order(created_at: :desc)
  end

  # 通知を既読にする（Ajax想定）
  def update
    notification = current_user.notifications.find(params[:id])
    notification.update(read: true)
    head :ok
  end

  # ✅ フォロー申請の作成（申請ボタン押下時に呼ばれる）
  def create_follow_request
    target = User.find(params[:followed_id]) # フォロー申請を受ける側

    # 同一申請の重複を防止
    Notification.find_or_create_by!(
      user: target,                   # 受け取り手
      actor: current_user,            # 申請した側
      category: :follow_request,
      message: "#{current_user.username} さんからフォロー申請がありました"
    )

    redirect_to notifications_path(category: "follow_request"),
                notice: "フォロー申請を送信しました。"
  end

  # ✅ 承認（フォロー関係を成立させる）
  def approve_follow_request
    n = current_user.notifications.find(params[:id])
    follower = n.actor

    # フォロー関係を登録（重複防止）
    current_user.followers << follower unless current_user.followers.exists?(follower.id)

    n.update(read: true, message: "フォローを承認しました。")
    redirect_to notifications_path(category: "follow_request"),
                notice: "フォローを承認しました。"
  end

  # ✅ 否認（通知だけ更新）
  def reject_follow_request
    n = current_user.notifications.find(params[:id])
    n.update(read: true, message: "フォロー申請をお断りしました。")
    redirect_to notifications_path(category: "follow_request"),
                notice: "フォロー申請をお断りしました。"
  end

  private

  def require_login
    redirect_to login_path unless current_user
  end
end
