class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :petition

  validates :content, presence: true, length: { minimum: 5 }
end
