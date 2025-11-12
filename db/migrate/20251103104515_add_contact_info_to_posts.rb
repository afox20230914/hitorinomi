class AddContactInfoToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :contact_info, :string
  end
end
