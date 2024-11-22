class CreateLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :logs do |t|
      t.references :user, foreign_key: true
      t.string :ip_address
      t.string :action
      t.string :status
      t.text :details
      

      t.timestamps
    end
  end
end
