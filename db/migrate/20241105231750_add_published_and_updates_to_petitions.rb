class AddPublishedAndUpdatesToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_column :petitions, :published, :boolean, default: false
    add_column :petitions, :updates, :text
  end
end
