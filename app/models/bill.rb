class Bill < ApplicationRecord
  belongs_to :user

  has_rich_text :content
  has_rich_text :justification

  has_one :bill_committee
  accepts_nested_attributes_for :bill_committee
  has_many :signatures, dependent: :destroy
  has_many_attached :attachments

  MIN_SIGNATURES_FOR_REVIEW = 5
  
  # Statusy inicjatywy ustawodawczej
  enum status: { 
    draft: 0,                              # Faza robocza – obywatel tworzy inicjatywę ustawodawczą.
    committee_formation: 1,                 # Zbieranie podpisów na rzecz utworzenia komitetu.
    awaiting_committee_verification: 2,     # Czekanie na zatwierdzenie komitetu przez Marszałka (marshal).
    submitted: 3,                           # Komitet został zatwierdzony, inicjatywa złożona formalnie.
    under_review: 4,                        # Przegląd formalny przez Weryfikatora Wstępnego (initial_verifier).
    collecting_signatures: 5,               # Zbieranie wymaganej liczby podpisów (np. 100 000).
    awaiting_marshal_review: 6,             # Marszałek weryfikuje poprawność zebranych podpisów (marshal).
    committee_review: 7,                    # Rozpatrzenie inicjatywy przez komisję (committee_member lub committee_secretary).
    approved: 8,                            # Inicjatywa została przyjęta do dalszego procesu legislacyjnego.
    rejected: 9                             # Inicjatywa została odrzucona na dowolnym etapie.
  }
  
  validates :title, :content, :justification, presence: true
  validates :required_signatures, numericality: { only_integer: true, greater_than: 0 }
end
