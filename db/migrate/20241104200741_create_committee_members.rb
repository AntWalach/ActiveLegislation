class CreateCommitteeMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :committee_members do |t|
      t.references :bill_committee, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :role, null: false
      t.timestamps
    end


    remove_column :bill_committees, :chairman_id, :integer
    remove_column :bill_committees, :vice_chairman_id, :integer
  end
end
