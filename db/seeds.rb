# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'date'
def rand_in_range(from, to)
  rand * (to - from) + from
end
def rand_time(from, to=Time.now)
  Time.at(rand_in_range(from.to_f, to.to_f))
end
1042.times do
  HighFive.create(sender_id: rand(2..20), receiver_phone_number: '5554376972', receiver_name: 'Zak Nikolai', giver_name: Faker::Name.name, created_at: rand_time(6.days.ago))
end

637.times do
  HighFive.create(sender_id: 1, receiver_phone_number: '5553461972', receiver_name: Faker::Name.name, giver_name: 'Zak Nikolai', created_at: rand_time(6.days.ago))
end

HighFive.create(sender_id: 1, receiver_phone_number: '5554376972', receiver_name: 'Zak Nikolai', giver_name: 'Max Caldbury')
