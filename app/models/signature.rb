class Signature < ApplicationRecord
  belongs_to :user
  belongs_to :petition, optional: true
  belongs_to :bill, optional: true

  validates :user_id, uniqueness: { 
    scope: [:petition_id, :bill_id],
    message: "Już podpisałeś ten dokument"
  }

  validate :must_have_either_petition_or_bill

  private

  def must_have_either_petition_or_bill
    if petition_id.nil? && bill_id.nil?
      errors.add(:base, "Signature must belong to either a petition or a bill")
    end
  end
end