class AddDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :address, :string
    add_column :users, :postal_code, :string
    add_column :users, :city, :string
    add_column :users, :country, :string
    add_column :users, :pesel, :string
    add_column :users, :phone_number, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :verified, :boolean, default: false, null: false
  end
end
