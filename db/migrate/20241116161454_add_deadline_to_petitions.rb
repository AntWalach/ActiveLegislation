class AddDeadlineToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_column :petitions, :deadline, :datetime
  end
end
