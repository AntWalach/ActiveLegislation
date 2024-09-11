class UpdateUserTypesBasedOnRoleMask < ActiveRecord::Migration[7.1]
  def up
    User.reset_column_information
    
    User.find_each do |user|
      case user.role_mask
      when "A"
        user.update(type: 'Admin')
      when "O"
        user.update(type: 'Official')
      when "S"
        user.update(type: 'StandardUser')
      else
        user.update(type: 'StandardUser')
      end
    end
  end

  def down
    # W przypadku cofania migracji możemy przywrócić role_mask (jeśli nadal potrzebujesz)
    User.update_all(type: nil)
  end
end
