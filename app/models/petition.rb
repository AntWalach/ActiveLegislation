class Petition < ApplicationRecord
  belongs_to :user
  has_many :signatures, dependent: :destroy
  validates :title, presence: true
  validates :description, presence: true

  enum status: { pending: 0, under_review: 1, approved: 2, rejected: 3 }


  MIN_SIGNATURES_FOR_REVIEW = 100

  def ready_for_review?
    signatures.count >= MIN_SIGNATURES_FOR_REVIEW
  end


end
