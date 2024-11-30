class AddAdditionalFieldsToPetitions < ActiveRecord::Migration[7.1]
  def change
    add_column :petitions, :consent_to_publish, :boolean
    add_column :petitions, :business_name, :string
    add_column :petitions, :business_email, :string
    add_column :petitions, :representative_name, :string
  end
end
