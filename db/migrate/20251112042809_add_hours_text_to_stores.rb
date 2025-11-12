class AddHoursTextToStores < ActiveRecord::Migration[6.1]
  def change
    add_column :stores, :hours_text, :text
  end
end
