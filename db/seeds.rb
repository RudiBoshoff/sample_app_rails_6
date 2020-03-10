# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Generate the original users
User.create!(name: "Example User",
             email: "example@railstutorial.org",
             password: "123456",
             password_confirmation: "123456")

User.create!(name: "Rudi Boshoff",
             email: "rudiboshoff15@gmail.com",
             password: "Lichking9",
             password_confirmation: "Lichking9")

#  Generate new users

# Generate a bunch of additional users.
4.times do |n|
    user_name = Faker::Name.name
    user_email = "example-#{n+1}@railstutorial.org"
    user_password = "password"
    User.create!(name: user_name,
                 email: user_email,
                 password: user_password,
                 password_confirmation: user_password)
end

93.times do |n|
    user_name = Faker::Name.name
    user_email = "#{user_name.gsub(/\s+/,"").gsub(/\.+/,"")}#{n+1}#{["@gmail.com", "@yahoo.com", "@railstutorial.org"].shuffle.first}"
    user_password = "password"
    User.create!(name: user_name,
                 email: user_email,
                 password: user_password,
                 password_confirmation: user_password)
end