class AddCommitteeRolesToBillCommittees < ActiveRecord::Migration[7.1]
  def change
    add_column :bill_committees, :chairman_id, :integer
    add_index :bill_committees, :chairman_id
    add_column :bill_committees, :vice_chairman_id, :integer
    add_index :bill_committees, :vice_chairman_id
  end
end
