class BillCommittee < ApplicationRecord
  belongs_to :bill
  has_many :committee_signatures, dependent: :destroy
  has_many :committee_members, dependent: :destroy, class_name: 'CommitteeMember'
  has_many :users, through: :committee_members

  # Wirtualne atrybuty do obsługi formularza
  attr_accessor :chairman_email, :vice_chairman_email, :member_emails
  validate :minimum_committee_members

  private

  # Sprawdza, czy komitet posiada wymagane minimum członków (5 w tym przewodniczący i wiceprzewodniczący)
  def minimum_committee_members
    emails = [chairman_email, vice_chairman_email] + member_emails.to_s.split(',').map(&:strip)
    if emails.compact.uniq.size < 5
      errors.add(:base, "Komitet musi mieć co najmniej 5 członków, w tym przewodniczącego i wiceprzewodniczącego")
    end
  end
end
