class AddIdentifierToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_column :petitions, :identifier, :string
  end
end
