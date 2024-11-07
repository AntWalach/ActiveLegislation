# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

# Tworzenie urzędników z każdą rolą
require 'faker'
Faker::Config.locale = 'pl' # Ustawienie języka na polski
# Admin.create!(
#   email: "antek@gmail.com",
#   password: "Antek.123",
#   first_name: "Antoni",
#   last_name: "Wałach",
# )

# Official.create!(
#   email: "official@gmail.com",
#   password: "Antek.123",
#   first_name: "General",
#   last_name: "Official",
#   official_role: "official"
# )

# Official.create!(
#   email: "initial_verifier@gmail.com",
#   password: "Antek.123",
#   first_name: "Initial",
#   last_name: "Verifier",
#   official_role: "initial_verifier"
# )

# Official.create!(
#   email: "signature_verifier@gmail.com",
#   password: "Antek.123",
#   first_name: "Signature",
#   last_name: "Verifier",
#   official_role: "signature_verifier"
# )

# Official.create!(
#   email: "marshal@gmail.com",
#   password: "Antek.123",
#   first_name: "Main",
#   last_name: "Marshal",
#   official_role: "marshal"
# )

# Official.create!(
#   email: "vice_marshal@gmail.com",
#   password: "Antek.123",
#   first_name: "Vice",
#   last_name: "Marshal",
#   official_role: "vice_marshal"
# )

# Official.create!(
#   email: "committee_secretary@gmail.com",
#   password: "Antek.123",
#   first_name: "Committee",
#   last_name: "Secretary",
#   official_role: "committee_secretary"
# )

# Official.create!(
#   email: "committee_member@gmail.com",
#   password: "Antek.123",
#   first_name: "Committee",
#   last_name: "Member",
#   official_role: "committee_member"
# )

# Official.create!(
#   email: "petition_verifier@gmail.com",
#   password: "Antek.123",
#   first_name: "Petition",
#   last_name: "Verifier",
#   official_role: "petition_verifier"
# )

# Official.create!(
#   email: "petition_receiver@gmail.com",
#   password: "Antek.123",
#   first_name: "Petition",
#   last_name: "Receiver",
#   official_role: "petition_receiver"
# )



# StandardUser.create!(
#   email: "standard@gmail.com",
#   password: "Antek.123",
#   first_name: "Standard",
#   last_name: "Standard",
# )


# StandardUser.create!(
#   email: "standard2@gmail.com",
#   password: "Antek.123",
#   first_name: "Standard",
#   last_name: "Standard",
# )

# StandardUser.create!(
#   email: "standard3@gmail.com",
#   password: "Antek.123",
#   first_name: "Standard",
#   last_name: "Standard",
# )



# StandardUser.create!(
#   email: "standard4@gmail.com",
#   password: "Antek.123",
#   first_name: "Standard",
#   last_name: "Standard",
# )


# StandardUser.create!(
#   email: "standard5@gmail.com",
#   password: "Antek.123",
#   first_name: "Standard",
#   last_name: "Standard",
# )

# StandardUser.create!(
#   email: "standard6@gmail.com",
#   password: "Antek.123",
#   first_name: "Standard",
#   last_name: "Standard",
# )



# puts "Urzędnicy z różnymi rolami zostali utworzeni!"


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
  police_headquarters: 'Komenda Główna Policji',
  central_anti_corruption_bureau: 'Centralne Biuro Antykorupcyjne',
  national_health_fund: 'Narodowy Fundusz Zdrowia',
  internal_security_agency: 'Agencja Bezpieczeństwa Wewnętrznego',
  military_property_agency: 'Agencja Mienia Wojskowego',
  institute_of_freedom: 'Narodowy Instytut Wolności',
  state_labour_inspection: 'Państwowa Inspekcja Pracy',
  chief_sanitary_inspectorate: 'Główny Inspektorat Sanitarny',
  environmental_protection_inspectorate: 'Główny Inspektorat Ochrony Środowiska',
  electronic_communications_office: 'Urząd Komunikacji Elektronicznej',
  polish_investment_and_trade_agency: 'Polska Agencja Inwestycji i Handlu',
  polish_tourist_organisation: 'Polska Organizacja Turystyczna',
  national_bank_of_poland: 'Narodowy Bank Polski',
  water_management_authority: 'Krajowy Zarząd Gospodarki Wodnej',
  polish_development_fund: 'Polski Fundusz Rozwoju',
  city_hall: 'Urząd Miasta',
  county_office: 'Starostwo Powiatowe',
  voivodeship_office: 'Urząd Marszałkowski',
  city_council: 'Rada Miasta',
  county_council: 'Rada Powiatowa'
}

departments.each_pair do |key, department_name|
  Department.create!(
    name: department_name,
    city: Faker::Address.city,
    address: Faker::Address.street_address,
    postal_code: Faker::Address.zip_code,
    email: Faker::Internet.email(name: department_name.gsub(' ', '_').downcase)
  )
end

puts "Dodano #{departments.size} departamentów."