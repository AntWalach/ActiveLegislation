class AddAssignedOfficialToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_reference :petitions, :assigned_official, foreign_key: { to_table: :users }
  end
end
