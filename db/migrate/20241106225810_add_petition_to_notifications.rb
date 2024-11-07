class AddPetitionToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_reference :notifications, :petition, foreign_key: true
  end
end
