FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    street_address { Faker::Address.street_address }
    city { Faker::Address.city }
    state {Faker::Address.state }
    zip_code {Faker::Address.zip }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    role { 0 }
    activation_status { true }
  end
end
