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
  has_many :shared_petition_departments, dependent: :destroy
  has_many :shared_departments, through: :shared_petition_departments, source: :department
  belongs_to :merged_into, class_name: 'Petition', optional: true
  has_many :merged_petitions, class_name: 'Petition', foreign_key: 'merged_into_id', dependent: :destroy
  has_many :assigned_officials, dependent: :destroy
  has_many :assigned_users, through: :assigned_officials, source: :user
  has_rich_text :description
  has_rich_text :justification
  acts_as_taggable_on :tags
  acts_as_ordered_taggable_on :tags


  before_save :set_deadline, if: :status_changed_to_submitted?
  before_validation :handle_same_address
  before_create :generate_unique_identifier

  before_create :set_initial_dates
  after_update :notify_status_change, if: :saved_change_to_status?

  scope :completed, -> { where(completed: true) }
  scope :shared_with_department, ->(department) { joins(:shared_petition_departments).where(shared_petition_departments: { department_id: department.id }) }

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

  validates :third_party_name, presence: true, if: :third_party_petition?
  validates :business_name, :business_email, presence: true, if: :business_individual_petition?
  validates :representative_name, presence: true, if: :group_petition?
 


  def set_initial_dates
    self.submission_date ||= Time.current
    self.response_deadline ||= submission_date + 30.days # Przykładowy termin odpowiedzi
  end

  def notify_status_change
    Notification.notify_status_change(
      user,
      self,
      saved_change_to_status[0], # Poprzedni status
      saved_change_to_status[1]  # Nowy status
    )
  end

  def check_deadlines
    if Time.current > response_deadline
      Notification.notify_missed_deadline(user, self, response_deadline)
    elsif Time.current > response_deadline - 3.days
      Notification.notify_upcoming_deadline(user, self, response_deadline)
    end
  end
  def third_party_petition?
    petition_type == 'third_party'
  end
  

  def business_individual_petition?
    petition_type == 'business_individual'
  end

  def group_petition?
    petition_type == 'group_petition'
  end

  # def in_behalf_of_third_party?
  #   petition_type == 'third_party'
  # end

  def can_be_assigned_to?(user)
    assigned_official.nil? && shared_departments.include?(user.department)
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

  def merged?
    grouped_petition_id.present? || merged_into_id.present?
  end


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

  def self.submitted_between(start_date, end_date)
    where(created_at: start_date..end_date)
  end

  # Podział petycji według statusów
  def self.count_by_status
    group(:status).count
  end

  # Podział petycji według tagów (tematów)
  def self.count_by_tag
    joins(:tags).group('tags.name').count
  end

  # Liczba petycji przypisanych do departamentów
  def self.count_by_department
    joins(:department).group('departments.name').count
  end

  private

    def generate_unique_identifier
      # Przykładowy format: PET-2024-XXXX
      self.identifier = "PET-#{Time.current.year}-#{SecureRandom.hex(4).upcase}"
    end


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
