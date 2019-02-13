class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  validates :sale_price, presence: true

  def subtotal
    (quantity * sale_price).round(2)
  end
end
