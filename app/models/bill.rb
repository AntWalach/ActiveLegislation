class Bill < ApplicationRecord
  belongs_to :user

  has_rich_text :content
  has_rich_text :justification

  has_one :bill_committee
  accepts_nested_attributes_for :bill_committee
  has_many :signatures, dependent: :destroy
  
  enum status: { draft: 0, collecting_signatures: 1, submitted: 2, approved: 3, rejected: 4 }
  
  validates :title, :content, :justification, presence: true
  validates :required_signatures, numericality: { only_integer: true, greater_than: 0 }
end
