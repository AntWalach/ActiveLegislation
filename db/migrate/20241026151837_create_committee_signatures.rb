class CreateCommitteeSignatures < ActiveRecord::Migration[7.1]
  def change
    create_table :committee_signatures do |t|
      t.references :bill_committee, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
