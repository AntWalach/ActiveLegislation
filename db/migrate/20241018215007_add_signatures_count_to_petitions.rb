class AddSignaturesCountToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_column :petitions, :signatures_count, :integer, default: 0
  end
end
