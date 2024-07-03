json.extract! bill, :id, :title, :description, :user_id, :created_at, :updated_at
json.url bill_url(bill, format: :json)
