class AddPublicKeyToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :public_key, :text
  end
end
