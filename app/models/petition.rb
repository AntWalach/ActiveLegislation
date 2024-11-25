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
  has_many_attached :third_party_consents
  has_many :petition_views, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :voters, through: :votes, source: :user
  has_many :comments, dependent: :destroy


  has_rich_text :description
  has_rich_text :justification
  acts_as_taggable_on :tags
  acts_as_ordered_taggable_on :tags
  before_save :set_deadline, if: :status_changed_to_submitted?
  before_validation :handle_same_address
  belongs_to :merged_into, class_name: 'Petition', optional: true
  has_many :merged_petitions, class_name: 'Petition', foreign_key: 'merged_into_id', dependent: :destroy

  scope :completed, -> { where(completed: true) }

  with_options if: :basic_information_step? do |petition|
    petition.validates :petition_type, presence: true
    petition.validates :recipient, presence: true
    petition.validates :department_id, presence: true
  end

  # Validations for petitioner_details step
  with_options if: :petitioner_details_step? do |petition|
    petition.validates :creator_name, presence: true
    petition.validates :email, presence: true
    petition.validates :residence_street, presence: true
    petition.validates :residence_city, presence: true
    petition.validates :residence_zip_code, presence: true
  end

  # Validations for petition_details step
  with_options if: :petition_details_step? do |petition|
    petition.validates :title, presence: true
    petition.validates :description, presence: true
    petition.validates :justification, presence: true
  end

  # Validations for consents step
  with_options if: :consents_step? do |petition|
    petition.validates :gdpr_consent, acceptance: true
    petition.validates :privacy_policy, acceptance: true
  end
 

  def third_party_petition?
    petition_type == 'third_party'
  end
  

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
    rejected: 6,
    merged: 7
  }
  
  # Typy petycji
  enum petition_type: {
    private_individual: 0,  # Osoba prywatna
    business_individual: 1, # Osoba fizyczna prowadząca działalność
    group_petition: 2,      # Grupa osób
    third_party: 3          # Organizacja lub pełnomocnik
  }


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

  def restore_previous_status
    update(status: previous_status)
  end

  private


    def handle_same_address
      if same_address == '1' || same_address == true
        self.address_street = residence_street
        self.address_city = residence_city
        self.address_zip_code = residence_zip_code
      end
    end

    def basic_information_step?
      current_step == 'basic_information'
    end
  
    def petitioner_details_step?
      current_step == 'petitioner_details'
    end
  
    def petition_details_step?
      current_step == 'petition_details'
    end
  
    def consents_step?
      current_step == 'consents'
    end
end
