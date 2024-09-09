class AddStatusToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_column :petitions, :status, :integer
  end
end
