class AddCompletedToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_column :petitions, :completed, :boolean, default: false
  end
end
