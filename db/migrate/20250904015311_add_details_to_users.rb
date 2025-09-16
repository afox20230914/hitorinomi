class AddDetailsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :last_name, :string, null: false, default: ""
    add_column :users, :first_name, :string, null: false, default: ""
    add_column :users, :phone_number, :string, null: false, default: ""
    add_column :users, :birth_date, :date, null: false, default: "2000-01-01"
    add_column :users, :username, :string, null: false, default: ""
    add_column :users, :profile, :text
    add_column :users, :is_account_public, :boolean, default: true
    add_column :users, :is_visit_public, :boolean, default: true
  end
end