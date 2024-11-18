class CreateOfficialComments < ActiveRecord::Migration[7.1]
  def change
    create_table :official_comments do |t|
      t.references :petition, foreign_key: true
      t.references :users, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
