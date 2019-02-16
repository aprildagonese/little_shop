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
    # Item.joins(:order_items)
    #     .select("items.*, avg(order_items.updated_at - order_items.created_at) as avg_time")
    #     .where(id: self.id)
    #     .where(order_item.order.activation_status = 0)
    #     .group(:id)
    #     .first.avg_time
    #
    # order_items
    #     .select("avg(updated_at - created_at) as avg_time")
    #     .where(item_id: self.id)
    #     .group(:item_id)
    #     .first.avg_time
  end
end
