class AddProvinceToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :province, :string
  end
end
