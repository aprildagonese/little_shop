FactoryBot.define do
  factory :order_item do
    item
    order
    sale_price { Faker::Number.decimal(2, 2) }
    quantity { Faker::Number.decimal(1, 0)}
  end
end
