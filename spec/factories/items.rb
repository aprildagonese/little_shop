FactoryBot.define do
  factory :item do
    title { Faker::Food.dish }
    description { Faker::Food.description }
    image_url { "food" }
    quantity { Faker::Number.number(4) }
    price { Faker::Number.decimal(2, 2) }
    activation_status { 0 }
  end
end
