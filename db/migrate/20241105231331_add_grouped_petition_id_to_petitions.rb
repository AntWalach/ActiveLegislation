class AddGroupedPetitionIdToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_reference :petitions, :grouped_petition, foreign_key: { to_table: :petitions }
  end
end
