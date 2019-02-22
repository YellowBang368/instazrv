json.extract! post, :id, :desc, :images, :created_at, :updated_at
json.url post_url(post, format: :json)
