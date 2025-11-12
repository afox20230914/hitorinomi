class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  validates :vote_type, inclusion: { in: %w[good bad] }
  validates :user_id, uniqueness: { scope: :comment_id } # 同一コメントに重複投票禁止
end
