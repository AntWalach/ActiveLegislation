class AddPreviousStatusToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_column :petitions, :previous_status, :string
  end
end
