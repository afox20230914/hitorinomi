class Notification < ApplicationRecord
  # 受け取り側
  belongs_to :user

  # 発信者（ユーザー）
  belongs_to :actor, class_name: "User", optional: true

  enum category: {
    visit: 0,          # 来店通知
    follow_request: 1, # フォロー申請
    comment_good: 2,   # コメントGOOD
    post_status: 3     # 申請について
  }

  scope :unread, -> { where(read: false) }
end
