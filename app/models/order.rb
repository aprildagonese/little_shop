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

  def self.largest_orders
    joins(:order_items)
    .select('orders.id, SUM(order_items.quantity) AS total_quantity')
    .where(orders: {status: 1})
    .group(:id)
    .order('total_quantity desc')
    .limit(3)
  end

  def item_count
    order_items.sum(:quantity)
  end

  def total_cost
    order_items.sum("sale_price * quantity")
  end

  def change_status(change)
    if change == "cancel"
      update_attribute(:status, 2) if pending?
    elsif change == "fulfill"
      update_attribute(:status, 1) if pending?
    end
  end

  def cancel
    order_items.each do |order_item|
      order_item.cancel_item
      order_item.save
    end

    self.status = 2
  end

  def self.find_orders(user)
    Order.joins(:items)
         .where(order_items: {fulfillment_status: 0}, items: {user_id: user.id})
         .distinct
  end

  def user_items(user)
    OrderItem.joins(:item)
             .where(items: {user_id: user}, order_id: id)

  end

  def user_grand_total(user)
    OrderItem.joins(:item)
             .where(items: {user_id: user}, order_id: id)
             .sum('order_items.quantity * order_items.sale_price')
  end

  def user_total_items(user)
    OrderItem.joins(:item)
             .where(items: {user_id: user}, order_id: id)
             .sum('order_items.quantity')
  end

  def items_fulfilled?
    order_items.where(fulfillment_status: 0).count == 0
  end

  def check_status
    change_status("fulfill") if items_fulfilled?
  end

end
