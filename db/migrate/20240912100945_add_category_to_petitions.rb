class AddCategoryToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_column :petitions, :category, :string
  end
end
