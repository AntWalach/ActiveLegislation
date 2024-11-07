json.extract! department, :id, :name, :city, :address, :postal_code, :email, :created_at, :updated_at
json.url department_url(department, format: :json)
