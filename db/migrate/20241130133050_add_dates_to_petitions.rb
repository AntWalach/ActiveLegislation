class AddDatesToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_column :petitions, :submission_date, :datetime
    add_column :petitions, :response_deadline, :datetime
  end
end
