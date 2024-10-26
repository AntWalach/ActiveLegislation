class AddPetitionTypeToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_column :petitions, :petition_type, :integer
  end
end
