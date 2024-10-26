class CommitteeSignature < ApplicationRecord
  belongs_to :bill_committee
  belongs_to :user

  validates :user_id, uniqueness: { scope: :bill_committee_id, message: "Już poparłeś ten komitet" }
end