class AddTitleToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :title, :string
  end
end
