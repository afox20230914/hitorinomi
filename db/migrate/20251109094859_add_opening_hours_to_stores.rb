# db/migrate/20251109_add_opening_hours_to_stores.rb （最終確定版・全文）

class AddOpeningHoursToStores < ActiveRecord::Migration[6.1]
  def change
    # 曜日ごとに open1/close1/open2/close2/holiday を格納するJSON
    # confirm.html.erb と同等構造
    add_column :stores, :opening_hours_json, :text, comment: "営業時間（JSON形式：open1, close1, open2, close2, holiday）"
    add_column :stores, :irregular_holiday, :boolean, default: false, null: false, comment: "不定休フラグ"
  end
end
