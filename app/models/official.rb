class Official < User
    belongs_to :department, optional: true
    
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


    enum department: {
      # Ministerstwa
      ministry_of_education_and_science: 'Ministerstwo Edukacji i Nauki',
      ministry_of_health: 'Ministerstwo Zdrowia',
      ministry_of_finance: 'Ministerstwo Finansów',
      ministry_of_justice: 'Ministerstwo Sprawiedliwości',
      ministry_of_national_defence: 'Ministerstwo Obrony Narodowej',
      ministry_of_culture_and_national_heritage: 'Ministerstwo Kultury i Dziedzictwa Narodowego',
      ministry_of_infrastructure: 'Ministerstwo Infrastruktury',
      ministry_of_family_and_social_policy: 'Ministerstwo Rodziny i Polityki Społecznej',
      ministry_of_agriculture_and_rural_development: 'Ministerstwo Rolnictwa i Rozwoju Wsi',
      ministry_of_climate_and_environment: 'Ministerstwo Klimatu i Środowiska',
      ministry_of_interior_and_administration: 'Ministerstwo Spraw Wewnętrznych i Administracji',
      ministry_of_foreign_affairs: 'Ministerstwo Spraw Zagranicznych',
      ministry_of_development_and_technology: 'Ministerstwo Rozwoju i Technologii',
      ministry_of_state_assets: 'Ministerstwo Aktywów Państwowych',
      ministry_of_sport_and_tourism: 'Ministerstwo Sportu i Turystyki',
      ministry_of_digital_affairs: 'Ministerstwo Cyfryzacji',
      ministry_of_funds_and_regional_policy: 'Ministerstwo Funduszy i Polityki Regionalnej',
  
      # Urzędy centralne
      prime_minister_office: 'Kancelaria Prezesa Rady Ministrów',
      commissioner_for_civil_rights_protection: 'Rzecznik Praw Obywatelskich',
      commissioner_for_children_rights: 'Rzecznik Praw Dziecka',
      patient_rights_ombudsman: 'Rzecznik Praw Pacjenta',
      office_of_competition_and_consumer_protection: 'Urząd Ochrony Konkurencji i Konsumentów',
      central_statistical_office: 'Główny Urząd Statystyczny',
      agency_for_restructuring_and_modernization_of_agriculture: 'Agencja Restrukturyzacji i Modernizacji Rolnictwa',
  
      # Organy ścigania i wymiar sprawiedliwości
      national_prosecutors_office: 'Prokuratura Krajowa',
      police_headquarters: 'Komenda Główna Policji',
      central_anti_corruption_bureau: 'Centralne Biuro Antykorupcyjne',
  
      # Agencje specjalistyczne
      national_health_fund: 'Narodowy Fundusz Zdrowia',
      internal_security_agency: 'Agencja Bezpieczeństwa Wewnętrznego',
      military_property_agency: 'Agencja Mienia Wojskowego',
      institute_of_freedom: 'Narodowy Instytut Wolności',
  
      # Urzędy nadzoru i inspekcji
      state_labour_inspection: 'Państwowa Inspekcja Pracy',
      chief_sanitary_inspectorate: 'Główny Inspektorat Sanitarny',
      environmental_protection_inspectorate: 'Główny Inspektorat Ochrony Środowiska',
      electronic_communications_office: 'Urząd Komunikacji Elektronicznej',
  
      # Inne instytucje rządowe
      polish_investment_and_trade_agency: 'Polska Agencja Inwestycji i Handlu',
      polish_tourist_organisation: 'Polska Organizacja Turystyczna',
      national_bank_of_poland: 'Narodowy Bank Polski',
      water_management_authority: 'Krajowy Zarząd Gospodarki Wodnej',
      polish_development_fund: 'Polski Fundusz Rozwoju',
  
      # Jednostki samorządu terytorialnego
      city_hall: 'Urząd Miasta',
      county_office: 'Starostwo Powiatowe',
      voivodeship_office: 'Urząd Marszałkowski',
      city_council: 'Rada Miasta',
      county_council: 'Rada Powiatowa'
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
      %w[petition_receiver].include?(official_role)
    end
  end
  