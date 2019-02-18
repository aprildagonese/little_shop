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

  def self.find_orders(merchant)
    Order.joins(:items)
    .where(order_items: {status: "pending"}, items: {user_id: merchant.id})
    .distinct
  end

  def self.user_by_most_orders(merchant)
    User.joins(orders: :items)
        .select("users.*, count(orders.id) as user_orders")
        .where(items: {user_id: 1}, order_items: {status: "fulfilled"})
        .group(:id)
        .order("user_orders desc")
    Order.joins(:items)
         .select("order.users.*, sum(users.orders) as user_orders")
         .where(items: {user_id: merchant.id})
         .distinct
  end
end
