# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' , { name: 'Lord of the Rings' ])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

require_relative '../app/models/user.rb'
require_relative '../app/models/item.rb'
require_relative '../app/models/order.rb'

User.destroy_all
Item.destroy_all
Order.destroy_all
OrderItem.destroy_all

all_merchants = []
8.times do |merchant|
  name = Faker::Name.name
  street_address = Faker::Address.street_address
  city = Faker::Address.city
  state = Faker::Address.state
  zip_code = Faker::Address.zip
  email = Faker::Internet.unique.email
  password = 'password'
  role = 1
  activation_status = 0
  user = User.create(name: name, street_address: street_address, city: city, state: state, zip_code: zip_code, email: email, role: role, password: password, activation_status: activation_status)
  all_merchants << user
  6.times do
    title = Faker::Food.unique.dish
    description = Faker::Food.description
    quantity = Faker::Number.number(4)
    price = Faker::Commerce.price
    activation_status = 0
    user.items.create(title: title, description: description, quantity: quantity, price: price, activation_status: activation_status)
  end
end

name = 'test merchant'
street_address = Faker::Address.street_address
city = Faker::Address.city
state = Faker::Address.state
zip_code = Faker::Address.zip
email = 'merchant@test.com'
password = 'password'
role = 1
activation_status = 0
user = User.create!(name: name, street_address: street_address, city: city, state: state, zip_code: zip_code, email: email, role: role, password: password, activation_status: activation_status)
all_merchants << user
6.times do
  title = Faker::Food.unique.dish
  description = Faker::Food.description
  quantity = Faker::Number.number(4)
  price = Faker::Commerce.price
  activation_status = 0
  user.items.create(title: title, description: description, quantity: quantity, price: price, activation_status: activation_status)
end

10.times do |user|
  name = Faker::Name.name
  street_address = Faker::Address.street_address
  city = Faker::Address.city
  state = Faker::Address.state
  zip_code = Faker::Address.zip
  email = Faker::Internet.unique.email
  password = 'password'
  role = 0
  activation_status = 0
  user = User.create!(name: name, street_address: street_address, city: city, state: state, zip_code: zip_code, email: email, role: role, password: password, activation_status: activation_status)
  rand(1..8).times do
    status = 0
    created_at = rand(500).days.ago

    order = user.orders.create!(activation_status: status, created_at: created_at)
    rand(1..5).times do
      item = all_merchants.sample.items.sample
      #order_activation_status = 0
      OrderItem.create!(order: order, item: item, sale_price: item.price, quantity: rand(1..10))
    end
  end
end

name = 'test user'
street_address = Faker::Address.street_address
city = Faker::Address.city
state = Faker::Address.state
zip_code = Faker::Address.zip
email = 'user@test.com'
password = 'password'
role = 0
activation_status = 0
User.create!(name: name, street_address: street_address, city: city, state: state, zip_code: zip_code, email: email, role: role, password: password, activation_status: activation_status)
rand(1..8).times do
  status = 0
  created_at = rand(500).days.ago

  order = user.orders.create!(activation_status: status, created_at: created_at)
  rand(1..5).times do
    item = all_merchants.sample.items.sample
    #order_activation_status = 0
    OrderItem.create!(order: order, item: item, sale_price: item.price, quantity: rand(1..10))
  end
end

name = 'test admin'
street_address = Faker::Address.street_address
city = Faker::Address.city
state = Faker::Address.state
zip_code = Faker::Address.zip
email = 'admin@test.com'
password = 'password'
role = 2
activation_status = 0
User.create!(name: name, street_address: street_address, city: city, state: state, zip_code: zip_code, email: email, role: role, password: password, activation_status: activation_status)

user_names = "List of user logins\n\n"
User.all.each do |user|
  user_names += "User: Role: #{user.role}, Email: #{user.email}, password: 'password'\n"
end
file_path = './db/user_login_credentials.txt'
File.open(file_path, 'w') { |file| file.write(user_names) }
