class AddDepartmentAndOfficeLocationToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :department, :string
    add_column :users, :office_location, :string
  end
end
