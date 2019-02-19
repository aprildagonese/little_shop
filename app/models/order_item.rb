class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  validates :sale_price, presence: true

  enum fulfillment_status: [:pending, :fulfilled, :unfulfilled]

  def subtotal
    (quantity * sale_price).round(2).to_i
  end

  def cancel_item
    if fulfilled?
      item.quantity += quantity
      item.save
    end

    self.fulfillment_status = 2
  end

  def in_stock?
    item.quantity >= self.quantity
  end

  def fulfull_order_item
  end

end
