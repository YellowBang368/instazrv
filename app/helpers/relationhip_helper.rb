module RelationhipHelper
  def follow?(user)
    Relationship.where(follower_id: current_user.id, followed_id: user.id).exists?
  end
end
