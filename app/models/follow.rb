class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"

  validates :follower_id, presence: true
  validates :followee_id, presence: true
  validates :follower_id, uniqueness: { scope: :followee_id, message: "既にフォロー済みです" }
  
  validate :cannot_follow_self

  scope :recent, -> { order(created_at: :desc) }

  private

  def cannot_follow_self
    return unless follower_id.present? && followee_id.present?
    
    errors.add(:followee_id, "自分自身をフォローすることはできません") if follower_id == followee_id
  end
end
