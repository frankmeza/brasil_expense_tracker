require './dependencies'
require 'mongoid'
require 'faker'

Mongoid.configure do
  env = ENV['RACK_ENV'] || 'development'
  Mongoid.load!('./config/mongoid.yml', env)
end

# empty the database
Mongoid::Config.purge! # doesn't work?
User.all.delete
Expense.all.delete

# # # # # # # #
#  seed data  #
# # # # # # # #

admin = User.create!(
  username: 'ADMIN',
  email: 'admin@email.com',
  password: 'password',
  is_admin: true
)

alpha = User.create!(
  username: 'alpha',
  email: 'alpha@email.com',
  password: 'password'
)

# Users
8.times do
  User.create!(
    username: Faker::Name.first_name,
    email: Faker::Internet.email,
    password: 'password',
    is_admin: false
  )
end

# Expenses
10.times do
  Expense.create!(
    vendor: Faker::Company.name,
    amount: Faker::Number.number(3),
    date: Faker::Time.between(DateTime.now - 100, DateTime.now),
    description: Faker::Hipster.paragraph
  )
end

puts 'Seeding is complete.'
puts 'Admin data: #=>'
puts admin.get_data
puts "JWT_TOKEN: #{AuthCtrl.encode_data(admin.data_for_token)}"
puts ''
puts '##########'
puts ''
puts 'Alpha User data: #=>'
puts alpha.get_data
puts "JWT_TOKEN: #{AuthCtrl.encode_data(alpha.data_for_token)}"
puts "There are #{Expense.all.size} expenses."
