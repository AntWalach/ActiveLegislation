class CreatePetitions < ActiveRecord::Migration[7.1]
  def change
    create_table :petitions do |t|
      t.string :title
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
