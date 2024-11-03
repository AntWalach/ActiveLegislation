class AddRoleToOfficials < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :official_role, :string
  end
end
