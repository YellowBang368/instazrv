json.users do
  json.array!(@users) do |user|
    json.username user.username
    json.url user_path(user)
  end
end
