class Petition < ApplicationRecord
  belongs_to :user
  has_many :signatures, dependent: :destroy
  has_one_attached :attachment

  has_rich_text :description
  has_rich_text :justification

  validates :title, presence: true
  validates :description, presence: true
  validates :recipient, presence: true
  validates :petition_type, presence: true
  validates :signature_goal, numericality: { only_integer: true, greater_than: 0 }
  validates :gdpr_consent, acceptance: true
  validates :privacy_policy, acceptance: true

  # Statusy petycji
  enum status: { 
    draft: 0,                  # Faza robocza – inicjator (obywatel) tworzy petycję.
    submitted: 1,              # Obywatel składa petycję do weryfikacji formalnej.
    under_review: 2,           # Weryfikator Petycji sprawdza zgodność z wymogami formalnymi.
    collecting_signatures: 3,   # Petycja wymagająca podpisów przechodzi do zbierania głosów.
    awaiting_verification: 4,   # Po osiągnięciu progu podpisów, petycja oczekuje na ich weryfikację przez Weryfikatora.
    awaiting_response: 5,       # Petycja oczekuje na rozpatrzenie przez odbiorcę (instytucję lub organ publiczny).
    responded: 6,               # Odpowiedź została udzielona, proces zakończony.
    rejected: 7                 # Petycja została odrzucona na dowolnym etapie.
  }
  
  # Typy petycji
  enum petition_type: { 
    individual: 0,      # Indywidualna (bez wymogu zbierania podpisów)
    group_petition: 1,  # Grupa (wymaga podpisów)
    organizational: 2,  # Organizacja (wymaga podpisów)
    public_interest: 3  # Interes publiczny (zwykle bez wymogu podpisów)
  }

  MIN_SIGNATURES_FOR_REVIEW = 5

  # Sprawdza, czy petycja osiągnęła minimalny próg podpisów do przejścia dalej
  def ready_for_review?
    Rails.logger.debug "Current signatures_count: #{signatures_count} - Required: #{MIN_SIGNATURES_FOR_REVIEW}"
    signatures_count >= MIN_SIGNATURES_FOR_REVIEW
  end

  # Sprawdza, czy petycja wymaga zbierania podpisów (tylko dla grupy lub organizacji)
  def requires_signatures?
    group_petition? || organizational?
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
