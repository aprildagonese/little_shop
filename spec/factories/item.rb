FactoryBot.define do
  factory :item, class: Item do
    user
    title { Faker::Food.unique.dish }
    description { Faker::Food.description }
    quantity { Faker::Number.number(4) }
    price { Faker::Number.decimal(2, 2) }
    active { true }
    image_url { 'https://cdn.shopify.com/s/files/1/0004/8132/9204/products/gummi-pickle1_2_1_1_1024x1024.jpg?v=1522430300' }
    slug { Faker::Internet.unique.slug }
  end

  factory :disabled_item, parent: :item do
    active { false }
  end
end
