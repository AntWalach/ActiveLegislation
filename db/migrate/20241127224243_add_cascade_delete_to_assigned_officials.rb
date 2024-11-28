class AddCascadeDeleteToAssignedOfficials < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :assigned_officials, :petitions
    add_foreign_key :assigned_officials, :petitions, on_delete: :cascade
  end
end
