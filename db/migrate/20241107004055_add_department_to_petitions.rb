class AddDepartmentToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_reference :petitions, :department, foreign_key: true
  end
end
