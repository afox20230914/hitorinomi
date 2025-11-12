# app/models/store.rb
class Store < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :post           # ← これだけでOK（stores.post_id を使う）

  has_many :visits, dependent: :destroy
  has_many :users, through: :visits
  has_many :visitors, through: :visits, source: :user

  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  has_many :comments, dependent: :destroy

  # メイン画像最大4枚
  has_one_attached :main_image_1
  has_one_attached :main_image_2
  has_one_attached :main_image_3
  has_one_attached :main_image_4

  has_many_attached :interior_images
  has_many_attached :exterior_images
  has_many_attached :food_images
  has_many_attached :menu_images

  # ❌ 削除：posts テーブルに store_id は無いので矛盾する
  # has_many :posts, dependent: :destroy

  # 公開投稿に紐づく店舗のみ
  scope :published, -> { joins(:post).where(posts: { status: '公開' }).distinct }
end
