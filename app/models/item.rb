class Item < ApplicationRecord
  belongs_to :user
  has_many :order_items#, dependent: :delete_all
  has_many :orders, through: :order_items#, dependent: :delete_all

  validates :title, uniqueness: true, presence: true
  validates :description, presence: true
  validates :quantity, presence: true
  validates :price, presence: true

  def subtotal
    price * quantity
  end

  def fulfillment_time
    time = Item.joins(:orders)
      .where(id: self, orders: {status: 1})
      .group(:id)
      .select("avg(order_items.updated_at - order_items.created_at) as avg_time").first

    if !time.nil?
      time.avg_time
    else
      "N/A"
    end
  end
end
