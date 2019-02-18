class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items#, dependent: :delete_all
  has_many :items, through: :order_items#, dependent: :delete_all

  enum status: [:pending, :fulfilled, :cancelled]

  def self.generate_order(cart, current_user)
    order = Order.create(user: current_user)
    cart.each do |item_id, qty|
      item = Item.find(item_id)
      order.order_items.create(item: item, quantity: qty, sale_price: item.price)
    end
  end

  def item_count
    order_items.sum(:quantity)
  end

  def total_cost
    order_items.sum(:sale_price)
  end

  def change_status
    update_attribute(:status, 2) if pending?
  end

  def cancel
    order_items.each do |order_item|
      order_item.cancel_item
    end
    update(status: 2)
  end

end
