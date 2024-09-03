class AddDigitalSignatureToSignatures < ActiveRecord::Migration[7.1]
  def change
    add_column :signatures, :digital_signature, :text
  end
end
