class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item
  
  validates :sale_price, presence: true
end
