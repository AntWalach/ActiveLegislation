class CommitteeMember < ApplicationRecord
    belongs_to :bill_committee
    belongs_to :user
  
    enum role: { chairman: 'chairman', vice_chairman: 'vice_chairman', member: 'member' }
  end
  