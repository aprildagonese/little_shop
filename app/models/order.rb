class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items#, dependent: :delete_all
  has_many :items, through: :order_items#, dependent: :delete_all

  enum status: [:pending, :fulfilled, :cancelled]

  def item_count
    order_items.sum(:quantity)
  end

  def total_cost
    order_items.sum(:sale_price)
  end

  def change_status
    update_attribute(:status, 2) if pending?
  end

end
