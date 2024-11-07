class PetitionComment < ApplicationRecord
  belongs_to :petition
  belongs_to :official, class_name: 'Official'

  enum comment_type: { general: 'general', request_supplement: 'request_supplement', response: 'response' }
end
