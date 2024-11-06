class AddThirdPartyFieldsToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_column :petitions, :third_party_name, :string
    add_column :petitions, :third_party_address, :string
  end
end
