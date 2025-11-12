class User < ApplicationRecord
  # ActiveStorage
  has_one_attached :icon

  # 関連
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_stores, through: :favorites, source: :store
  has_many :visits, dependent: :destroy
  has_many :visited_stores, through: :visits, source: :store
  has_many :comments, dependent: :destroy

  # 🔔 通知関連（追加）
  has_many :notifications, dependent: :destroy                 # 自分宛の通知（受け取り側）
  has_many :active_notifications,                              # 自分が発信した通知
           class_name: "Notification",
           foreign_key: "actor_id",
           dependent: :destroy

# フォロー機能関連
has_many :active_relationships, class_name: "Relationship",
                                foreign_key: "follower_id",
                                dependent: :destroy
has_many :passive_relationships, class_name: "Relationship",
                                 foreign_key: "followed_id",
                                 dependent: :destroy

has_many :following, through: :active_relationships, source: :followed
has_many :followers, through: :passive_relationships, source: :follower


  # パスワード関連
  has_secure_password validations: false
  attr_accessor :password_confirmation

  # バリデーション
  validates :last_name,  presence: { message: "を入力してください" },
                         format:   { with: /\A[ぁ-んァ-ン一-龥々]+\z/, message: "は全角で入力してください" }
  validates :first_name, presence: { message: "を入力してください" },
                         format:   { with: /\A[ぁ-んァ-ン一-龥々]+\z/, message: "は全角で入力してください" }
  validates :email,      presence:   { message: "を入力してください" },
                         uniqueness: { message: "はすでに使用されています" },
                         format:     { with: /\A[^@\s]+@[^@\s]+\z/, message: "は有効なメールアドレス形式で入力してください" }
  validates :phone_number, presence:   { message: "を入力してください" },
                           uniqueness: { message: "はすでに使用されています" },
                           format:     { with: /\A\d{10,11}\z/, message: "はハイフンなしの半角数字で入力してください" }
  validates :username,   presence:   { message: "を入力してください" },
                         uniqueness: { message: "はすでに使用されています" }
  validates :birth_date, presence: { message: "を入力してください" }

  # パスワード（日本語エラーメッセージ）
  validates :password, presence: { message: "を入力してください" },
                       length:   { minimum: 8, message: "は8文字以上で入力してください" },
                       if: :password_required?
  validates :password_confirmation, presence: { message: "を入力してください" },
                                    if: :password_required?
  validate  :passwords_match, if: :password_required?

  validate  :must_be_over_20

  private

  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end

  def passwords_match
    return if password.blank? && password_confirmation.blank?
    errors.add(:password_confirmation, "が一致しません") if password != password_confirmation
  end

  def must_be_over_20
    return if birth_date.blank?
    errors.add(:birth_date, "は20歳未満の方は登録できません") if birth_date > 20.years.ago.to_date
  end
end
