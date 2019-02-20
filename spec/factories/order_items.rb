FactoryBot.define do
  factory :order_item do
    item
    order
    sale_price { Faker::Number.decimal(2, 2) }
    quantity { Faker::Number.number(2) }
    fulfillment_status { 0 }
  end

  factory :fulfilled_order_item, parent: :order_item do
    fulfillment_status { 1 }
  end
end
