class AddHoursTextToPostsAndStores < ActiveRecord::Migration[6.1]
  def change
    add_column :posts,  :hours_text, :text unless column_exists?(:posts,  :hours_text)
    add_column :stores, :hours_text, :text unless column_exists?(:stores, :hours_text)
  end
end
