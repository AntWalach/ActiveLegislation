class AddCurrentStepToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_column :petitions, :current_step, :string
    add_column :petitions, :email, :string
  end
end
