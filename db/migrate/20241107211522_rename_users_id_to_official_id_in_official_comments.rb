class RenameUsersIdToOfficialIdInOfficialComments < ActiveRecord::Migration[7.1]
  def change
    rename_column :official_comments, :users_id, :official_id
    
    # Usunięcie starego klucza obcego do users
    remove_foreign_key :official_comments, :users
    
    # Dodanie nowego klucza obcego do users, wskazującego na official_id
    add_foreign_key :official_comments, :users, column: :official_id
  end
end
