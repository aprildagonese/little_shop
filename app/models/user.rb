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

  def self.highest_revenues
    joins(items: :orders)
    .select('users.*, SUM(order_items.sale_price * order_items.quantity) AS total_revenue')
    .where(orders: {status: 1}, role: 1)
    .group(:id)
    .order('total_revenue desc')
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

  def total_revenue
    items.joins(:orders)
         .where(orders: {status: 1})
         .sum('sale_price * order_items.quantity')
  end
end
