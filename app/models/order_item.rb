class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  validates :sale_price, presence: true

  enum fulfillment_status: [:pending, :fulfilled, :unfulfilled]

  def subtotal
    (quantity * sale_price).round(2)
  end

  def cancel_item
    if fulfilled?
      item.quantity = item.quantity + quantity
      item.save
    end

    self.fulfillment_status = 2
  end

  # def self.total_sold_quantity(merchant)
  #   OrderItem.select("sum(order_items.quantity) as total_quantity")
  #            .joins(:items)
  #            .group("items.user_id")
  #            .where("items.user_id = ?", merchant.id)
  # end

    # select items.user_id, sum(order_items.quantity)
    #   as total_quantity from order_items
    #  inner join items on order_items.item_id = items.id
    #  group by items.user_id;

end
