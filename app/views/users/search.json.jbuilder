json.users do
  json.array!(@users) do |user|
    json.username user.username
    json.url user_path(user)
    json.fullname user.fullname
    json.avatar_path post_avatar(user)
  end
end
