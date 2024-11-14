require 'faker'
Faker::Config.locale = 'pl' # Ustawienie języka na polski

# Tworzenie administratora
Admin.create!(
  email: "antek@gmail.com",
  password: "Antek.123",
  first_name: "Antoni",
  last_name: "Wałach"
)

# Tworzenie przykładowych użytkowników standardowych
5.times do |i|
  StandardUser.create!(
    email: "standard#{i + 1}@gmail.com",
    password: "Antek.123",
    first_name: "Standard#{i + 1}",
    last_name: "User"
  )
end

# Lista departamentów z możliwością posiadania oddziałów w różnych miastach
departments = {
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
  prime_minister_office: 'Kancelaria Prezesa Rady Ministrów',
  commissioner_for_civil_rights_protection: 'Rzecznik Praw Obywatelskich',
  commissioner_for_children_rights: 'Rzecznik Praw Dziecka',
  patient_rights_ombudsman: 'Rzecznik Praw Pacjenta',
  office_of_competition_and_consumer_protection: 'Urząd Ochrony Konkurencji i Konsumentów',
  central_statistical_office: 'Główny Urząd Statystyczny',
  agency_for_restructuring_and_modernization_of_agriculture: 'Agencja Restrukturyzacji i Modernizacji Rolnictwa',
  national_prosecutors_office: 'Prokuratura Krajowa',
  police_headquarters: 'Komenda Główna Policji', # Może mieć lokalizacje w różnych miastach
  city_hall: 'Urząd Miasta',                     # Może mieć lokalizacje w różnych miastach
  county_office: 'Starostwo Powiatowe',          # Może mieć lokalizacje w różnych miastach
  voivodeship_office: 'Urząd Marszałkowski',      # Może mieć lokalizacje w różnych miastach
  sejm: 'Sejm Rzeczypospolitej Polskiej',         # Tylko Sejm ma marszałków i wicemarszałków
  senat: 'Senat Rzeczypospolitej Polskiej'        # Tylko Senat ma marszałków i wicemarszałków
}

# Tworzenie departamentów z urzędnikami w losowych miastach
departments.each_pair do |key, department_name|
  # Tworzenie 3 losowych lokalizacji dla departamentów, które mogą mieć wiele oddziałów
  cities = if %i[police_headquarters city_hall county_office voivodeship_office].include?(key)
             Array.new(3) { Faker::Address.city }.uniq # Losowe miasta
           else
             [Faker::Address.city] # Jeden urząd centralny
           end

  cities.each do |city|
    department = Department.create!(
      name: department_name,
      city: city,
      address: Faker::Address.street_address,
      postal_code: Faker::Address.zip_code,
      email: Faker::Internet.email(name: department_name.gsub(' ', '_').downcase)
    )

    # Wybór ról w zależności od rodzaju departamentu
    roles = if %i[sejm senat].include?(key)
              %w[marshal vice_marshal committee_secretary committee_member petition_verifier petition_receiver]
            else
              %w[initial_verifier signature_verifier petition_verifier petition_receiver]
            end

    # Tworzenie urzędników z wybranymi rolami dla tego departamentu
    roles.each do |role|
      Official.create!(
        email: Faker::Internet.email(name: "#{role}_#{city}".downcase),
        password: "Antek.123",
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        official_role: role,
        department: department
      )
    end
  end
end

puts "Dodano departamenty i przypisanych urzędników w różnych lokalizacjach."
