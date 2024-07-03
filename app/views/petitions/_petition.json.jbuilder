json.extract! petition, :id, :title, :description, :user_id, :created_at, :updated_at
json.url petition_url(petition, format: :json)
