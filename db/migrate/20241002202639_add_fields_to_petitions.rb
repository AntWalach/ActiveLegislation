class AddFieldsToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_column :petitions, :address, :string
    add_column :petitions, :recipient, :string
    add_column :petitions, :justification, :text
  end
end
