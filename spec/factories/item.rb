FactoryBot.define do
  factory :item do
    user
    title { Faker::Food.unique.dish }
    description { Faker::Food.description }
    quantity { Faker::Number.number(4) }
    price { Faker::Number.decimal(2, 2) }
    activation_status { 0 }
  end
end
