class BillCommittee < ApplicationRecord
  belongs_to :bill
  has_many :committee_signatures, dependent: :destroy
  has_many :users, through: :committee_signatures

  attr_accessor :chairman_email, :vice_chairman_email,
                :member_email_1, :member_email_2, :member_email_3, 
                :member_email_4, :member_email_5, :member_email_6,
                :member_email_7, :member_email_8, :member_email_9, 
                :member_email_10, :member_email_11, :member_email_12, 
                :member_email_13

  # validates :bill_id, presence: true

  private

end