module UsersHelper

  def follows(user)
    return Relationship.where(follower_id: current_user.id, followed_id: user.id).exists?
  end
end
