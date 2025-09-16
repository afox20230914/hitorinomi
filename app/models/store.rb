class Store < ApplicationRecord
  belongs_to :user, optional: true

  has_many :visits
  has_many :visitors, through: :visits, source: :user

  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user

  has_many :comments, dependent: :destroy

  has_one_attached :main_image_1
end
