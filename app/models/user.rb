class User < ApplicationRecord
  has_many :orders
  #as a merchant
  has_many :items

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates_presence_of :password, require: true
  #validates :password_confirmation, presence: true

  has_secure_password

  enum role: [:registered, :merchant, :admin]
  enum activation_status: [:active, :inactive]

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

end
