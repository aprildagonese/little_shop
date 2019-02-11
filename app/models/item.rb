class Item < ApplicationRecord
  belongs_to :user
  has_many :order_items#, dependent: :delete_all
  has_many :orders, through: :order_items#, dependent: :delete_all

  validates_presence_of :name
end
