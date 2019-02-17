FactoryBot.define do
  factory :user, class: User do
    name { Faker::Name.name }
    street_address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip_code { Faker::Address.zip }
    email { Faker::Internet.unique.email}
    password { Faker::Internet.password }
    role { 0 }
    activation_status { 0 }
  end

  factory :merchant, parent: :user do
    name { Faker::Restaurant.name }
    role { 1 }
    activation_status { 0 }
  end
end
