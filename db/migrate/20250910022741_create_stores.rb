class CreateStores < ActiveRecord::Migration[6.1]
  def change
    create_table :stores do |t|
      t.string  :name
      t.string  :postal_code
      t.string  :prefecture
      t.string  :city
      t.string  :address_detail
      t.time    :opening_time
      t.time    :closing_time
      t.string  :seating_capacity
      t.string  :store_type
      t.string  :smoking_allowed
      t.text    :holidays
      t.integer :budget
      t.text    :description
      t.string  :main_image_1
      t.string  :main_image_2
      t.string  :main_image_3
      t.string  :main_image_4
      t.text    :interior_images
      t.text    :exterior_images
      t.text    :food_images
      t.text    :menu_images
      t.references :user, foreign_key: true
      t.boolean :is_owner

      t.timestamps
    end
  end
end

