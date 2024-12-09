# db/seeds.rb

require 'faker'
Faker::Config.locale = 'pl' # Ustawienie języka na polski

# Lista miast wojewódzkich
voivodeship_capitals = [
  'Warszawa',          # Mazowieckie
  'Kraków',            # Małopolskie
  'Łódź',              # Łódzkie
  'Wrocław',           # Dolnośląskie
  'Poznań',            # Wielkopolskie
  'Gdańsk',            # Pomorskie
  'Szczecin',          # Zachodniopomorskie
  'Bydgoszcz',         # Kujawsko-Pomorskie (wraz z Toruniem)
  'Lublin',            # Lubelskie
  'Białystok',         # Podlaskie
  'Katowice',          # Śląskie
  'Kielce',            # Świętokrzyskie
  'Rzeszów',           # Podkarpackie
  'Olsztyn',           # Warmińsko-Mazurskie
  'Opole',             # Opolskie
  'Gorzów Wielkopolski', # Lubuskie (wraz z Zieloną Górą)
  'Zielona Góra',
  'Toruń'
]

# Lista miast gminnych
municipal_cities = [
  'Zakopane',
  'Sopot',
  'Kołobrzeg',
  'Płock',
  'Częstochowa',
  'Radom',
  'Elbląg',
  'Legnica',
  'Kalisz',
  'Tarnów'
]

# # Tworzenie administratora
# Admin.find_or_create_by!(email: "antek@gmail.com") do |admin|
#   admin.password = "Antek.123"
#   admin.first_name = "Antoni"
#   admin.last_name = "Wałach"
# end

# # Tworzenie przykładowych użytkowników standardowych
# 5.times do |i|
#   StandardUser.find_or_create_by!(email: "standard#{i + 1}@gmail.com") do |user|
#     user.password = "Antek.123"
#     user.first_name = "Standard#{i + 1}"
#     user.last_name = "User"
#   end
# end

# # Tworzenie użytkowników składających petycje
user1 = StandardUser.find_or_create_by!(email: 'standard1@gmail.com') do |user|
  user.password = 'Antek.123'
  user.first_name = 'Stowarzyszenie'
  user.last_name = 'Czyste Powietrze'
end

user2 = StandardUser.find_or_create_by!(email: 'standard1@gmail.com') do |user|
  user.password = 'Antek.123'
  user.first_name = 'Rada Rodziców'
  user.last_name = 'SP5'
end

user3 = StandardUser.find_or_create_by!(email: 'standard1@gmail.com') do |user|
  user.password = 'Antek.123'
  user.first_name = 'Fundacja Wspierania'
  user.last_name = 'Osób Niepełnosprawnych'
end

# # Lista departamentów z możliwością posiadania oddziałów w różnych miastach
# departments = {
#   ministry_of_education_and_science: 'Ministerstwo Edukacji i Nauki',
#   ministry_of_health: 'Ministerstwo Zdrowia',
#   ministry_of_finance: 'Ministerstwo Finansów',
#   ministry_of_justice: 'Ministerstwo Sprawiedliwości',
#   ministry_of_national_defence: 'Ministerstwo Obrony Narodowej',
#   ministry_of_culture_and_national_heritage: 'Ministerstwo Kultury i Dziedzictwa Narodowego',
#   ministry_of_infrastructure: 'Ministerstwo Infrastruktury',
#   ministry_of_family_and_social_policy: 'Ministerstwo Rodziny i Polityki Społecznej',
#   ministry_of_agriculture_and_rural_development: 'Ministerstwo Rolnictwa i Rozwoju Wsi',
#   ministry_of_climate_and_environment: 'Ministerstwo Klimatu i Środowiska',
#   ministry_of_interior_and_administration: 'Ministerstwo Spraw Wewnętrznych i Administracji',
#   ministry_of_foreign_affairs: 'Ministerstwo Spraw Zagranicznych',
#   ministry_of_development_and_technology: 'Ministerstwo Rozwoju i Technologii',
#   ministry_of_state_assets: 'Ministerstwo Aktywów Państwowych',
#   ministry_of_sport_and_tourism: 'Ministerstwo Sportu i Turystyki',
#   ministry_of_digital_affairs: 'Ministerstwo Cyfryzacji',
#   ministry_of_funds_and_regional_policy: 'Ministerstwo Funduszy i Polityki Regionalnej',
#   prime_minister_office: 'Kancelaria Prezesa Rady Ministrów',
#   commissioner_for_civil_rights_protection: 'Rzecznik Praw Obywatelskich',
#   commissioner_for_children_rights: 'Rzecznik Praw Dziecka',
#   patient_rights_ombudsman: 'Rzecznik Praw Pacjenta',
#   office_of_competition_and_consumer_protection: 'Urząd Ochrony Konkurencji i Konsumentów',
#   central_statistical_office: 'Główny Urząd Statystyczny',
#   agency_for_restructuring_and_modernization_of_agriculture: 'Agencja Restrukturyzacji i Modernizacji Rolnictwa',
#   national_prosecutors_office: 'Prokuratura Krajowa',
#   police_headquarters: 'Komenda Główna Policji', # Może mieć lokalizacje w różnych miastach
#   city_hall: 'Urząd Miasta',                     # Może mieć lokalizacje w różnych miastach
#   county_office: 'Starostwo Powiatowe',          # Może mieć lokalizacje w różnych miastach
#   voivodeship_office: 'Urząd Marszałkowski',     # Może mieć lokalizacje w różnych miastach
#   sejm: 'Sejm Rzeczypospolitej Polskiej',        # Tylko Sejm ma marszałków i wicemarszałków
#   senat: 'Senat Rzeczypospolitej Polskiej'       # Tylko Senat ma marszałków i wicemarszałków
# }

# # Tworzenie departamentów z urzędnikami w losowych miastach
# departments.each_pair do |key, department_name|
#   # Tworzenie 3 losowych lokalizacji dla departamentów, które mogą mieć wiele oddziałów
#   cities = if %i[police_headquarters city_hall county_office voivodeship_office].include?(key)
#              Array.new(3) { Faker::Address.city }.uniq # Losowe miasta
#            else
#              ["Warszawa"] # Jeden urząd centralny
#            end

#   cities.each do |city|
#     department = Department.create!(
#       name: department_name,
#       city: city,
#       address: Faker::Address.street_address,
#       postal_code: Faker::Address.zip_code,
#       email: Faker::Internet.email(name: department_name.gsub(' ', '_').downcase)
#     )

#     # Wybór ról w zależności od rodzaju departamentu
#     roles = if %i[sejm senat].include?(key)
#               %w[marshal vice_marshal committee_secretary committee_member petition_officer]
#             else
#               %w[petition_officer]
#             end

#     # Tworzenie urzędników z wybranymi rolami dla tego departamentu
#     roles.each do |role|
#       Official.create!(
#         email: Faker::Internet.email(name: "#{role}_#{city}".downcase),
#         password: "Antek.123",
#         first_name: Faker::Name.first_name,
#         last_name: Faker::Name.last_name,
#         official_role: role,
#         department: department
#       )
#     end
#   end
# end

puts "Dodano departamenty i przypisanych urzędników w różnych lokalizacjach."

# Znajdź departament odpowiedzialny za środowisko
environment_department = Department.find_by(name: 'Ministerstwo Klimatu i Środowiska')

# Tworzenie petycji
petition_env = Petition.new(
  title: 'Podjęcie działań na rzecz poprawy jakości powietrza w mieście',
  petition_type: 'private_individual',
  recipient: 'Minister Klimatu i Środowiska',
  department: environment_department,
  creator_name: 'Stowarzyszenie Czyste Powietrze',
  address: 'ul. Zielona 10, 00-001 Warszawa',
  gdpr_consent: true,
  privacy_policy: true,
  status: :draft, 
  tag_list: 'środowisko, powietrze, zdrowie, ekologia',
  user: user1, # Przypisanie użytkownika
  completed: true
)

petition_env.description = <<~DESC
  Szanowny Panie Ministrze,

  Jako mieszkańcy miasta, zauważamy znaczne pogorszenie jakości powietrza, szczególnie w okresie zimowym. Wysoki poziom smogu negatywnie wpływa na nasze zdrowie i komfort życia. Prosimy o podjęcie pilnych działań mających na celu redukcję zanieczyszczeń powietrza.
DESC

petition_env.justification = <<~JUST
  **Uzasadnienie:**

  - **Zdrowie publiczne**: Wzrost liczby zachorowań na choroby układu oddechowego, szczególnie wśród dzieci i osób starszych.
  - **Środowisko**: Zanieczyszczenie powietrza wpływa negatywnie na faunę i florę miejską.
  - **Obowiązki międzynarodowe**: Polska jest zobowiązana do przestrzegania norm jakości powietrza według przepisów UE.

  Proponujemy:

  - Wprowadzenie programów dofinansowania wymiany starych pieców na ekologiczne źródła ciepła.
  - Zwiększenie kontroli emisji przemysłowych.
  - Promocję transportu publicznego i rowerowego.

  Liczymy na pozytywne rozpatrzenie naszej petycji i podjęcie działań dla dobra nas wszystkich.
JUST

petition_env.save!

# Znajdź departament odpowiedzialny za edukację
education_department = Department.find_by(name: 'Ministerstwo Edukacji i Nauki')

# Tworzenie petycji
petition_edu = Petition.new(
  title: 'Modernizacja infrastruktury szkół podstawowych w regionie',
  petition_type: 'private_individual',
  recipient: 'Minister Edukacji i Nauki',
  department: environment_department,
  creator_name: 'Rada Rodziców Szkoły Podstawowej nr 5',
  address: 'ul. Szkolna 15, 00-002 Kraków',
  gdpr_consent: true,
  privacy_policy: true,
  status: :draft,
  tag_list: 'edukacja, infrastruktura, dzieci, szkoła',
  user: user2,
  completed: true
)

petition_edu.description = <<~DESC
  Szanowny Panie Ministrze,

  Zwracamy się z prośbą o wsparcie finansowe i organizacyjne w celu modernizacji infrastruktury naszej szkoły. Budynek szkoły od wielu lat nie przechodził gruntownego remontu, co negatywnie wpływa na warunki nauki naszych dzieci.
DESC

petition_edu.justification = <<~JUST
  **Uzasadnienie:**

  - **Bezpieczeństwo**: Pękające ściany i nieszczelne okna stanowią zagrożenie dla uczniów i pracowników.
  - **Warunki edukacyjne**: Przestarzałe wyposażenie klas utrudnia realizację nowoczesnych programów nauczania.
  - **Równość szans**: Dzieci z naszej szkoły powinny mieć dostęp do takich samych warunków edukacyjnych jak ich rówieśnicy w innych placówkach.

  Prosimy o:

  - Przyznanie środków na remont budynku szkoły.
  - Dofinansowanie zakupu nowoczesnego sprzętu dydaktycznego.
  - Wsparcie w organizacji programów edukacyjnych rozwijających kompetencje cyfrowe uczniów.

  Wierzymy, że inwestycja w edukację jest inwestycją w przyszłość naszego kraju.
JUST

petition_edu.save!

# Znajdź departament odpowiedzialny za infrastrukturę
infrastructure_department = Department.find_by(name: 'Ministerstwo Infrastruktury')

# Tworzenie petycji
petition_trans = Petition.new(
  title: 'Poprawa dostępności komunikacji miejskiej dla osób niepełnosprawnych',
  petition_type: 'private_individual',
  recipient: 'Minister Infrastruktury',
  department: environment_department,
  creator_name: 'Fundacja Wspierania Osób Niepełnosprawnych',
  address: 'ul. Pomocna 8, 00-003 Poznań',
  gdpr_consent: true,
  privacy_policy: true,
  status: :draft,
  tag_list: 'transport, niepełnosprawni, komunikacja miejska, dostępność',
  user: user3,
  completed: true  
  )

petition_trans.description = <<~DESC
  Szanowny Panie Ministrze,

  W imieniu osób z niepełnosprawnościami zwracamy się z prośbą o podjęcie działań mających na celu poprawę dostępności komunikacji miejskiej. Obecnie wiele pojazdów nie jest przystosowanych do potrzeb osób poruszających się na wózkach inwalidzkich czy mających problemy z poruszaniem się.
DESC

petition_trans.justification = <<~JUST
  **Uzasadnienie:**

  - **Prawo do równego dostępu**: Osoby niepełnosprawne mają prawo do swobodnego korzystania z transportu publicznego.
  - **Integracja społeczna**: Ułatwienie przemieszczania się sprzyja aktywizacji zawodowej i społecznej tych osób.
  - **Zobowiązania międzynarodowe**: Polska jest sygnatariuszem Konwencji o prawach osób niepełnosprawnych.

  Proponowane działania:

  - Modernizacja taboru komunikacyjnego poprzez zakup pojazdów niskopodłogowych.
  - Szkolenia dla kierowców z zakresu obsługi osób niepełnosprawnych.
  - Instalacja udogodnień, takich jak rampy, sygnalizacja dźwiękowa i wizualna.

  Liczymy na zrozumienie i wsparcie w tej ważnej sprawie.
JUST

petition_trans.save!

puts 'Dodano petycje z przypisanymi użytkownikami.'
