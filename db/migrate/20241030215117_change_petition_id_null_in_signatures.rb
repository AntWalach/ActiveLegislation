class ChangePetitionIdNullInSignatures < ActiveRecord::Migration[7.1]
  def change
    change_column_null :signatures, :petition_id, true
  end
end
