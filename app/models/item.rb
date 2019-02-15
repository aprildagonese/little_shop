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
    5
    # Item.joins(:order_items)
    #   .select("items.*, avg(order_items.updated_at - order_items.created_at) as avg_time")
    #   .where(id: id)
    #   #.group(:id)
  end
end
