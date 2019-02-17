class Item < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :orders, through: :order_items

  validates :title, uniqueness: true, presence: true
  validates :description, presence: true
  validates :quantity, presence: true
  validates :price, presence: true

  def fulfillment_time
    time = Item.joins(:orders)
      .where(id: self, orders: {status: 1})
      .group(:id)
      .select("avg(order_items.updated_at - order_items.created_at) as avg_time").first

    if !time.nil?
      time = time.avg_time
      time.split("days").first + "days, " + time.split("days").last.split(":").first.strip.to_i.round(0).to_s +  " hours"
    else
      nil
    end
  end

  def self.most_popular
    Item.joins(:orders)
    .select("items.*, sum(order_items.quantity) as total_quantity")
    .where(orders: {status: 1})
    .group(:id)
    .order("total_quantity desc")
  end

  def self.least_popular
    Item.joins(:orders)
    .select("items.*, sum(order_items.quantity) as total_quantity")
    .where(orders: {status: 1})
    .group(:id)
    .order("total_quantity asc")
  end

  def self.top_items_sold(merchant)
    Item.joins(:orders)
        .select("items.*, sum(order_items.quantity) as total_quantity")
        .group(:id)
        .order("total_quantity desc")
  end

  def units_sold
    order_items.sum("order_items.quantity")
  end

  def self.total_sold_quantity(merchant)
    Item.joins(:order_items)
       .select("items.user_id, sum(order_items.quantity) as total_quantity")
       .group("items.user_id")
       .where("items.user_id = ?", merchant.id)
  end

end
