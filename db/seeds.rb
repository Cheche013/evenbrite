# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "faker"

puts "Reset…"
Attendance.delete_all
Event.delete_all
User.delete_all

puts "Users…"
admins = []
5.times do |i|
  admins << User.create!(
    email: "admin#{i+1}@yopmail.com",
    encrypted_password: "password", 
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    description: Faker::Lorem.paragraph(sentence_count: 2)
  )
end

puts "Events…"
events = []
10.times do
  start = Faker::Time.forward(days: rand(2..40), period: :evening)
  events << Event.create!(
    admin: admins.sample,
    start_date: start,
    duration: [30, 60, 90, 120, 180].sample,
    title: Faker::Book.title[0..139].ljust(5, "x"),
    description: Faker::Lorem.paragraph_by_chars(number: 220, supplemental: false),
    price: rand(1..1000),
    location: Faker::Address.city
  )
end

puts "Attendees…"
users = []
10.times do |i|
  users << User.create!(
    email: "user#{i+1}@yopmail.com",
    encrypted_password: "password",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    description: Faker::Lorem.sentence(word_count: 10)
  )
end

users.each do |u|
  rand(1..3).times do
    e = events.sample
    Attendance.create!(
      user: u,
      event: e,
      stripe_customer_id: "cus_#{SecureRandom.hex(8)}"
    )
  end
end

puts "OK"