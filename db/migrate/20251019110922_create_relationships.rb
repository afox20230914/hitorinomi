class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      # ✅ Userテーブルを参照するよう明示指定
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :followed, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    # ✅ 重複防止インデックス
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
