class User < ApplicationRecord
  has_secure_password
  has_one_attached :icon
  has_many :visits
  has_many :visited_stores, through: :visits, source: :store
  has_many :comments, dependent: :destroy
  has_many :applications
  has_many :favorites, dependent: :destroy
  has_many :favorite_stores, through: :favorites, source: :store


  # バリデーション
  validates :last_name, :first_name, presence: true,
            format: { with: /\A[ぁ-んァ-ン一-龥々]+\z/, message: "は全角で入力してください" }

  validates :email, presence: true, uniqueness: true,
            format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "は有効なメールアドレス形式で入力してください" }

  validates :phone_number, uniqueness: true,
            format: { with: /\A\d{10,11}\z/, message: "はハイフンなしの半角数字で入力してください" }

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }
  validates :password_confirmation, presence: true, if: -> { new_record? || !password.nil? }

  validates :birth_date, presence: true
  validate :must_be_over_20

  validate :password_presence_check
  validate :password_confirmation_check

  private

  def password_presence_check
    if password.blank?
      errors.add(:password, "を入力してください")
    end

    if password_confirmation.blank?
      errors.add(:password_confirmation, "を入力してください")
    end
  end

  def password_confirmation_check
    return if password.blank? || password_confirmation.blank?

    if password != password_confirmation
      errors.delete(:password_confirmation)
      errors.add(:password_confirmation, "確認用パスワードが一致しません")
    end
  end

  def must_be_over_20
    return if birth_date.blank?
    if birth_date > 20.years.ago.to_date
      errors.add(:birth_date, "は20歳未満の方は登録できません")
    end
  end
end
