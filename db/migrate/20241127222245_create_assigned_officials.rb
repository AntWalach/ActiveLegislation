class CreateAssignedOfficials < ActiveRecord::Migration[7.1]
  def change
    create_table :assigned_officials do |t|
      t.references :petition, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
