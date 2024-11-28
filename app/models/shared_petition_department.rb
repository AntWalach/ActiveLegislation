class SharedPetitionDepartment < ApplicationRecord
  belongs_to :petition
  belongs_to :department
end
