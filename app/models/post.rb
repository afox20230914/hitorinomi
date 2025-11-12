# frozen_string_literal: true

class Post < ApplicationRecord
  # ActiveStorage
  has_many_attached :images
  has_many_attached :main_images
  has_many_attached :sub_images
  has_many_attached :exterior_images      # 店舗外観
  has_many_attached :interior_images      # 店舗内観
  has_many_attached :food_images          # 料理
  has_many_attached :menu_images          # メニュー

  has_one :store, dependent: :destroy
  accepts_nested_attributes_for :store

  # 正規化
  before_validation :normalize_is_owner

  # バリデーション
  validates :name, presence: true, length: { maximum: 100 }
  validates :postal_code, format: { with: /\A\d{7}\z/ }, allow_blank: true
  validates :description, length: { maximum: 500 }, allow_blank: true
  validates :is_owner, inclusion: { in: [true, false] }
  STATUSES = %w[公開前 公開 公開保留].freeze
  validates :status, inclusion: { in: STATUSES }

  validate :image_count_limit

  private

  # フォームが「そうです/いいえ」や "true"/"false" を返す場合に対応
  def normalize_is_owner
    case is_owner
    when 'そうです', 'true', true then self.is_owner = true
    when 'いいえ',  'false', false then self.is_owner = false
    end
  end

  # 画像は合計10枚まで（images + main_images + sub_images）
  def image_count_limit
    total =
      images.attachments.size +
      main_images.attachments.size +
      sub_images.attachments.size

    if total > 10
      errors.add(:base, '画像は合計10枚までしかアップロードできません')
    end
  end
end
