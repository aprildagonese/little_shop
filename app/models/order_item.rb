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
      item.quantity += quantity
      item.save
    end

    self.fulfillment_status = 2
  end
end
