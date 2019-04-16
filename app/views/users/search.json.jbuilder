json.users do
  json.array!(@users) do |user|
    json.username user.username
    json.url user_path(user)
    json.name "Anton Azarov"
    json.avatar_path post_avatar(user)
  end
end
