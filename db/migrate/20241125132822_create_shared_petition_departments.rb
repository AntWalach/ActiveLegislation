class CreateSharedPetitionDepartments < ActiveRecord::Migration[7.1]
  def change
    create_table :shared_petition_departments do |t|
      t.references :petition, foreign_key: true
      t.references :department, foreign_key: true

      t.timestamps
    end
  end
end
