class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user,  null: false, foreign_key: true        # 通知の受け取り側
      t.references :actor, null: true,  foreign_key: { to_table: :users }  # 発信者(User)
      t.integer :category, null: false                           # 0:visit,1:follow_request,2:comment_good,3:post_status
      t.string  :message,  null: false
      t.boolean :read,     null: false, default: false

      t.timestamps
    end
  end
end
