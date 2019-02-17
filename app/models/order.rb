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

  def self.find_orders(user)
    # select orders. * from orders inner join order_items
    #     on orders.id = order_items.order_id
    #     join items on order_items.item_id = items.id
    #     where items.user_id = 1;
    Order.joins(:items).where(items: {user_id: user.id}, status: "pending").distinct
  end
end
