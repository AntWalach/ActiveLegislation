class AddViewsToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_column :petitions, :views, :integer, default: 0
  end
end
