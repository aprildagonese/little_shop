class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items#, dependent: :delete_all
  has_many :items, through: :order_items#, dependent: :delete_all

  enum status: [:pending, :fulfilled, :cancelled]

  def self.generate_order(cart)
    order = Order.create
    cart.each do |item_id, qty|
      item = Item.find(item_id.to_i)
      order.order_items.create(item: item, quantity: qty, sale_price: item.price)
    end
  end
end
