class AddAddressFieldsToPetitions < ActiveRecord::Migration[7.1]
  def change
    # Pola adresu zamieszkania lub siedziby
    add_column :petitions, :residence_street, :string
    add_column :petitions, :residence_city, :string
    add_column :petitions, :residence_zip_code, :string

    # Pola adresu do korespondencji
    add_column :petitions, :address_street, :string
    add_column :petitions, :address_city, :string
    add_column :petitions, :address_zip_code, :string

    # Pola adresu osoby trzeciej (jeśli dotyczy)
    add_column :petitions, :third_party_street, :string
    add_column :petitions, :third_party_city, :string
    add_column :petitions, :third_party_zip_code, :string

    add_column :petitions, :same_address, :boolean
  end
end
