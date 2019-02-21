class User < ApplicationRecord
  has_many :orders
  has_many :items

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates_presence_of :password, require: true

  has_secure_password

  enum role: [:registered, :merchant, :admin]
  enum activation_status: [:active, :inactive]

  def self.highest_revenues
    joins(items: :orders)
    .select('users.*, SUM(order_items.sale_price * order_items.quantity) AS total_revenue')
    .where(orders: {status: 1}, role: 1)
    .group(:id)
    .order('total_revenue desc')
    .limit(3)
  end

  def self.fastest_fulfillments
    joins(items: :orders)
    .select('users.*, AVG(order_items.updated_at - order_items.created_at) as avg_time')
    .where(orders: {status: 1}, role: 1)
    .group(:id)
    .order("avg_time asc")
    .limit(3)
  end

  def self.slowest_fulfillments
    joins(items: :orders)
    .select('users.*, AVG(order_items.updated_at - order_items.created_at) as avg_time')
    .where(orders: {status: 1}, role: 1)
    .group(:id)
    .order('avg_time desc')
    .limit(3)
  end

  def self.most_orders_by_state
    joins(orders: :order_items)
    .select('users.state, COUNT(DISTINCT orders.id) AS total_orders')
    .where(orders: {status: 1}, role: 0)
    .group(:state)
    .order('total_orders desc')
    .limit(3)
  end

  def self.most_orders_by_city
    joins(orders: :order_items)
    .select('users.city, users.state, COUNT(DISTINCT orders.id) AS total_orders')
    .where(orders: {status: 1}, role: 0)
    .group(:city, :state)
    .order('total_orders desc')
    .limit(3)
  end

  def change_status
    if activation_status == "active"
      update_attribute(:activation_status, 1)
    else
      update_attribute(:activation_status, 0)
    end
  end

  def downgrade
    items.each do |item|
      item.update_attribute(:active, false)
    end
    update_attribute(:role, 0)
  end

  def upgrade
    update_attribute(:role, 1)
  end

  def top_states(limit)
     User.joins(orders: {order_items: :item})
          .select('users.state, SUM(order_items.quantity) AS total_items')
          .where(items: {user_id: self.id}, order_items: {fulfillment_status: 1})
          .group(:state)
          .order('total_items desc')
          .limit(limit)
  end

  def top_city_states(limit)
    User.joins(orders: {order_items: :item})
        .select('users.city, users.state, SUM(order_items.quantity) AS total_items')
        .where(items: {user_id: self.id}, order_items: {fulfillment_status: 1})
        .group(:city, :state)
        .order('total_items desc')
        .limit(limit)
  end

  def top_spending_patrons(limit)
    User.joins(orders: {order_items: :item})
        .select('users.name, SUM(order_items.sale_price * order_items.quantity) AS total_spent')
        .where(items: {user_id: self.id}, order_items: {fulfillment_status: 1})
        .group(:name)
        .order('total_spent desc')
        .limit(limit)
  end

  def most_items_patrons(limit)
    User.joins(orders: {order_items: :item})
        .select('users.name, SUM(order_items.quantity) AS total_items_qty')
        .where(items: {user_id: self.id}, order_items: {fulfillment_status: 1})
        .group(:name)
        .order('total_items_qty desc')
        .limit(limit)
  end

  def most_orders_patrons(limit)
    User.joins(orders: {order_items: :item})
        .select('users.name, COUNT(order_items) AS total_orders')
        .where(items: {user_id: self.id}, order_items: {fulfillment_status: 1})
        .group(:name)
        .order('total_orders desc')
        .limit(limit)
  end

end
