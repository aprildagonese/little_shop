class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  validates :sale_price, presence: true

  enum status: [:pending, :fulfilled]

  def subtotal
    (quantity * sale_price).round(2)
  end

end
