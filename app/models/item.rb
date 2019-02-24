require 'uri'

class Item < ApplicationRecord
  before_create :create_slug

  belongs_to :user
  has_many :order_items
  has_many :orders, through: :order_items

  validates :title, uniqueness: true, presence: true
  validates :description, presence: true
  validates :quantity, presence: true
  validates :price, presence: true
  validates :slug, presence: true, uniqueness: true

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

  def ordered?
    OrderItem.pluck(:item_id).include?(self.id)
  end

  def self.top_items_sold(merchant)
    Item.joins(:orders)
        .select("items.*, sum(order_items.quantity) as total_quantity")
        .where(items: {user: merchant})
        .group(:id)
        .order("total_quantity desc")
  end

  def create_slug
    if title
      slug = title.downcase
      slug.gsub!(/[:@ _\&;~^`|%#?;<>=\/\{\}\[\]\\]/, '-')
      slug.squeeze!('-')
      self.slug = slug
    end
  end

  def units_sold
    order_items.sum("order_items.quantity")
  end

  def self.total_sold_quantity(merchant)
    Item.joins(:order_items)
        .where(items: {user_id: merchant.id}, order_items: {fulfillment_status: 1})
        .sum("order_items.quantity")
  end

  def self.total_inventory(merchant)
    total_in_stock = Item.where(user: merchant).sum(:quantity)
    total_sold = total_sold_quantity(merchant)
    total_inventory = total_in_stock + total_sold
  end

  def self.percent_sold(merchant)
    result = ((total_sold_quantity(merchant).to_f/total_inventory(merchant).to_f)*100).round(2)
    if result == 0
      result = "N/A"
    else
      result
    end
  end

  def change_status
    if active
      update_attribute(:active, false)
    else
      update_attribute(:active, true)
    end
  end

end
