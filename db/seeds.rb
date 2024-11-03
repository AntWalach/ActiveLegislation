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

StandardUser.create!(
  email: "standard3@gmail.com",
  password: "Antek.123",
  first_name: "Standard",
  last_name: "Standard",
)



StandardUser.create!(
  email: "standard4@gmail.com",
  password: "Antek.123",
  first_name: "Standard",
  last_name: "Standard",
)


StandardUser.create!(
  email: "standard5@gmail.com",
  password: "Antek.123",
  first_name: "Standard",
  last_name: "Standard",
)


puts "Urzędnicy z różnymi rolami zostali utworzeni!"
