class Comment < ApplicationRecord
  belongs_to :user       # ←これが抜けてる
  belongs_to :store
  has_many :votes, dependent: :destroy

  def good_count
    votes.where(vote_type: "good").count
  end

  def bad_count
    votes.where(vote_type: "bad").count
  end
end
