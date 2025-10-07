class CreateVisits < ActiveRecord::Migration[6.1]
  def change
    create_table :visits do |t|
      t.integer :user_id
      t.integer :store_id
      t.datetime :visited_at
      t.timestamps
    end
  end
end
