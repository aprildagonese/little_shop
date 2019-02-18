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
      item = Item.find(item_id)
      item.update(quantity: (item.quantity += quantity))
    end
    update(fulfillment_status: 2)
  end
end
