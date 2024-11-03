class Official < User

    
    enum official_role: { 
      official: 'official',          # Ogólny urzędnik
      initial_verifier: 'initial_verifier', # Weryfikator Wstępny
      signature_verifier: 'signature_verifier', # Urzędnik ds. Kompletności Głosów
      marshal: 'marshal',             # Marszałek
      vice_marshal: 'vice_marshal',   # Wicemarszałek
      committee_secretary: 'committee_secretary', # Sekretarz Komisji
      committee_member: 'committee_member',       # Członek Komisji
      petition_verifier: 'petition_verifier',     # Weryfikator Petycji
      petition_receiver: 'petition_receiver'      # Odbiorca Petycji
    }
  
    def official?
      official_role == 'official'
    end
  
    def marshal?
      %w[marshal vice_marshal].include?(official_role)
    end
  
    def committee_member?
      %w[committee_secretary committee_member].include?(official_role)
    end
  
    def petition_handler?
      %w[petition_verifier petition_receiver].include?(official_role)
    end
  end
  