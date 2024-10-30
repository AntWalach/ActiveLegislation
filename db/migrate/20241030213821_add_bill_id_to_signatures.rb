class AddBillIdToSignatures < ActiveRecord::Migration[7.1]
  def change
    add_column :signatures, :bill_id, :bigint
    add_foreign_key :signatures, :bills
    add_index :signatures, :bill_id
  end
end
