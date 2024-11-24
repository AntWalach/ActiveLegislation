class AddMergedIntoIdToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_column :petitions, :merged_into_id, :bigint
    add_index :petitions, :merged_into_id
    add_foreign_key :petitions, :petitions, column: :merged_into_id
  end
end
