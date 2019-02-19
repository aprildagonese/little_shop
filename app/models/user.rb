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
    User.joins("join orders on users.id = orders.user_id join order_items on orders.id = order_items.order_id")
        .select("select users.name from users")
        .select()
        .where("where orders.user_id = ?", merchant.id)
        .group(:id)
        .order("user_orders asc")
        .first
  end
end
