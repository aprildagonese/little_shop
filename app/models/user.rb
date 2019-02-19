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

  def self.user_by_most_orders(merchant)
    User.joins(orders: :items)
        .select("users.*, count(orders.id) as user_orders")
        .where(items: {user_id: merchant.id}, order_items: {status: 1})
        .group(:id)
        .order("user_orders asc")
        .first
  end
end
