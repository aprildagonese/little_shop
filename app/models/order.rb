class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items#, dependent: :delete_all
  has_many :items, through: :order_items#, dependent: :delete_all

  enum status: [:pending, :fulfilled, :cancelled]
end
