# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Generate the original users
user_password = "password"

User.create!(name: "Example User",
             email: "example@railstutorial.org",
             password: user_password,
             password_confirmation: user_password,
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name: "Rudi Boshoff",
             email: "rudiboshoff15@gmail.com",
             password: user_password,
             password_confirmation: user_password,
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

# Generate additional rails tutorial users.
4.times do |n|
    user_name = Faker::Name.name
    user_email = "example-#{n+1}@railstutorial.org"
    User.create!(name: user_name,
        email: user_email,
        password: user_password,
        password_confirmation: user_password,
        activated: true,
        activated_at: Time.zone.now)
    end
    
# Generate additional users with random email addresses.
    93.times do |n|
    user_name = Faker::Name.name
    user_email = "#{user_name.gsub(/\s+/,"").gsub(/[^A-Za-z0-9]/,"")}#{n+1}#{["@gmail.com", "@yahoo.com", "@railstutorial.org"].shuffle.first}"
    User.create!(name: user_name,
                 email: user_email,
                 password: user_password,
                 password_confirmation: user_password,
                 activated: true,
                 activated_at: Time.zone.now)
end

# generate microposts for the first 6 users
users = User.order(:created_at).take(6)
50.times do
    content = Faker::Lorem.sentence(word_count: 5)
    users.each { |user| user.microposts.create!(content: content) }
end