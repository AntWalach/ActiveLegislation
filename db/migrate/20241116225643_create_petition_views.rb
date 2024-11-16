class CreatePetitionViews < ActiveRecord::Migration[7.1]
  def change
    create_table :petition_views do |t|
      t.references :petition, foreign_key: true
      t.references :user, foreign_key: true
      t.string :ip_address

      t.timestamps
    end
  end
end
