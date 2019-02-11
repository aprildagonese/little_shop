class Item < ApplicationRecord
  has_many :order_items#, dependent: :delete_all
  has_many :orders, through: :order_items#, dependent: :delete_all

  validates_presence_of :title
end
