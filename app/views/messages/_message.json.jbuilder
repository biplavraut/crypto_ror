json.extract! message, :id, :name, :email, :phone, :message, :key, :created_at, :updated_at
json.url message_url(message, format: :json)
