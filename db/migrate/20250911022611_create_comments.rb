# db/migrate/XXXX_create_comments.rb
class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true
      t.text :body
      t.integer :good_count, default: 0
      t.integer :bad_count, default: 0

      t.timestamps
    end
  end
end
