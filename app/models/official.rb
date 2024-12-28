class Official < User
    belongs_to :department, optional: true
    has_many :assigned_officials, dependent: :destroy
    has_many :petitions, through: :assigned_officials

    
    enum official_role: { 
      initial_verifier: 'initial_verifier', # Weryfikator Wstępny
      signature_verifier: 'signature_verifier', # Urzędnik ds. Kompletności Głosów
      marshal: 'marshal',             # Marszałek
      vice_marshal: 'vice_marshal',   # Wicemarszałek
      committee_secretary: 'committee_secretary', # Sekretarz Komisji
      committee_member: 'committee_member',       # Członek Komisji
      petition_officer: 'petition_officer'
    }

    def marshal?
      %w[marshal vice_marshal].include?(official_role)
    end
  
    def committee_member?
      %w[committee_secretary committee_member].include?(official_role)
    end
  
    def petition_handler?
      %w[petition_officer].include?(official_role)
    end
  end
  