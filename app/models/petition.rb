class Petition < ApplicationRecord
  belongs_to :user
  has_many :signatures, dependent: :destroy
  validates :title, presence: true
  validates :description, presence: true
end
