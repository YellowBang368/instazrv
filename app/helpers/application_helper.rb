module ApplicationHelper
  def post_avatar(user)
    if user.avatar.present?
      return user.avatar.url
    else
      return "default.png"
    end
  end
end
