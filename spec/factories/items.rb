FactoryBot.define do
  factory :user do
    title { Faker::Food.dish }
    description { Faker::Food.description }
    img_url { "food" }
    quantity { Faker::Number.number }
    price { Faker::Number.decimal(2, 2) }
    activation_status { true }
  end
end
