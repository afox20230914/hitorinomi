class User < ApplicationRecord
  # 英語デフォ検証を止める
  has_secure_password validations: false

  # 日本語メッセージで統一
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

  # パスワード系（全部日本語）
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

