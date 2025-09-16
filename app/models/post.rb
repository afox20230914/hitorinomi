class Post < ApplicationRecord
  has_many_attached :images

  validates :name, presence: true, length: { maximum: 100 }
  validates :postal_code, format: { with: /\A\d{7}\z/ }, allow_blank: true
  validates :description, length: { maximum: 500 }, allow_blank: true
  validates :is_owner, inclusion: { in: [true, false] }

  serialize :holidays, Array
end
