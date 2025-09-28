class AddPostIdToStores < ActiveRecord::Migration[6.1]
  def change
    add_reference :stores, :post, null: true, foreign_key: true
  end
end
