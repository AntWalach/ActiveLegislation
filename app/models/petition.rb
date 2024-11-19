class Petition < ApplicationRecord
  belongs_to :user
  belongs_to :department, optional: true
  belongs_to :assigned_official, class_name: 'Official', optional: true
  has_many :signatures, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many_attached :attachments
  has_many :official_comments, dependent: :destroy
  has_many_attached :images
  has_one_attached :main_image
  has_rich_text :description
  has_rich_text :justification
  acts_as_taggable_on :tags
  acts_as_ordered_taggable_on :tags
  before_save :set_deadline, if: :status_changed_to_submitted?


  validates :title, presence: true
  validates :description, presence: true
  validates :recipient, presence: true
  validates :petition_type, presence: true
  validates :gdpr_consent, acceptance: true
  validates :privacy_policy, acceptance: true


  has_many_attached :third_party_consents

  validates :third_party_name, presence: true, if: :in_behalf_of_third_party?
  validates :third_party_address, presence: true, if: :in_behalf_of_third_party?
  validates :third_party_consent, presence: true, if: :in_behalf_of_third_party?

  def in_behalf_of_third_party?
    petition_type == 'third_party'
  end
  
  # Statusy petycji
  enum status: {
    draft: 0,
    submitted: 1,
    under_review: 2,
    awaiting_supplement: 3,
    responded: 5,
    rejected: 6
  }
  
  # Typy petycji
  enum petition_type: { 
    individual: 0,      
    group_petition: 1,  
    third_party: 2 
  }

  #MIN_SIGNATURES_FOR_REVIEW = 5


  # def ready_for_review?
  #   Rails.logger.debug "Current signatures_count: #{signatures.count} - Required: #{MIN_SIGNATURES_FOR_REVIEW}"
  #   signatures.count >= MIN_SIGNATURES_FOR_REVIEW
  # end


  # def requires_signatures?
  #   group_petition? || organizational?
  # end

  def editable_by?(user)
    (draft? || awaiting_supplement?) && self.user == user
  end


  def status_changed_to_submitted?
    status_changed? && status == 'submitted'
  end
  
  def set_deadline
    self.deadline = created_at + 3.months
  end
  

  def self.ransackable_attributes(auth_object = nil)
    [
      "address", "attachment", "category", "comments", "created_at", 
      "creator_name", "description", "end_date", "external_links", 
      "gdpr_consent", "id", "justification", "petition_type", "priority", 
      "privacy_policy", "public_comment", "recipient", "signature_goal", 
      "signatures_count", "status", "subcategory", "title", "updated_at", 
      "user_id"
    ]
  end
end
