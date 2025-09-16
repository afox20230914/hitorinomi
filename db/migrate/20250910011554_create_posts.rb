class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :name
      t.string :postal_code
      t.string :prefecture
      t.string :city
      t.string :address_detail
      t.time :opening_time
      t.time :closing_time
      t.string :seating_capacity
      t.string :store_type
      t.string :smoking_allowed
      t.text :holidays
      t.integer :budget, default: 1000
      t.text :description, limit: 500
      t.boolean :is_owner

      t.timestamps
    end
  end
end
