class CreateVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true
      t.references :petition, foreign_key: true

      t.timestamps
    end
    add_index :votes, [:user_id, :petition_id], unique: true
  end
end
