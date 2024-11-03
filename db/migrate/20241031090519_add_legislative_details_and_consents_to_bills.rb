class AddLegislativeDetailsAndConsentsToBills < ActiveRecord::Migration[7.1]
  def change
    change_table :bills, bulk: true do |t|
      # Pola zgód zgodnie z wymogami RODO i polityki prywatności
      t.boolean :gdpr_consent, default: false, null: false
      t.boolean :privacy_policy, default: false, null: false
      t.boolean :public_disclosure_consent, default: false, null: false

      # Pola wymagane do uzasadnienia i opisu projektu ustawy
      t.text :current_state               # Aktualny stan prawny lub społeczny
      t.text :proposed_changes            # Różnica między obecnym a proponowanym stanem
      t.text :expected_effects            # Skutki społeczne, gospodarcze, finansowe i prawne
      t.text :funding_sources             # Źródła finansowania, jeśli dotyczy
      t.text :implementation_guidelines    # Założenia aktów wykonawczych, jeśli dotyczy

      # Zgodność z prawem UE i uwagi dotyczące zgodności
      t.boolean :eu_compliance, default: false
      t.text :eu_remarks                  # Uzasadnienie zgodności lub braku zgodności z prawem UE
    end
  end
end
