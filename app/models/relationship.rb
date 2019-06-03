class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  #validations
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validate :validate_relationship
  
  private
  def validate_relationship
    errors.add(user: "Follower and followed can't be the same user!") if followed_id == follower_id
    errors.add(user: "Relationship exists!") if Relationship.where(follower_id: follower_id, followed_id: followed_id).exists?
  end
end
