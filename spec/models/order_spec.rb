require 'rails_helper'

RSpec.describe Order, type: :model do

  describe 'relationships' do
    it {should have_many :order_items}
    it {should have_many(:items).through :order_items}
    it {should belong_to :user}
  end

  describe 'validations' do
  end

  describe 'class methods' do
    it ".generate_order" do
      user = create(:user)
      item1 = create(:item)
      item2 = create(:item)
      item3 = create(:item)
      cart = {item1.id =>1, item2.id =>1, item3.id =>1}

      expect(Order.count).to eq(0)
      expect(OrderItem.count).to eq(0)

      Order.generate_order(cart, user)
      order = Order.last

      expect(Order.count).to eq(1)
      expect(OrderItem.count).to eq(3)
      expect(order.order_items[0].item).to eq(item1)
      expect(order.order_items[1].item).to eq(item2)
      expect(order.order_items[2].item).to eq(item3)
    end

    it ".find_orders" do
      Faker::UniqueGenerator.clear
      merchant1, merchant2 = create_list(:user, 2, role: 1)
      user1, user2, user3 = create_list(:user, 3, role: 0)
      item1, item2, item3 = create_list(:item, 3, user: merchant1)
      item4, item5 = create_list(:item, 2, user: merchant2)
      order1 = create(:order, user: user1)
      order2 = create(:order, user: user2)
      order3 = create(:order, user: user3)
      order4 = create(:order, user: user1)
      oi1 = create(:order_item, order: order1, item: item1, fulfillment_status: 1)
      oi2 = create(:order_item, order: order1, item: item3, fulfillment_status: 1)
      oi3 = create(:order_item, order: order2, item: item2)
      oi4 = create(:order_item, order: order2, item: item4, fulfillment_status: 1)
      oi5 = create(:order_item, order: order3, item: item1)
      oi6 = create(:order_item, order: order3, item: item2)
      oi7 = create(:order_item, order: order4, item: item4)
      oi8 = create(:order_item, order: order4, item: item5, fulfillment_status: 1)

      expected1 = [order2, order3]
      expected2 = [order4]

      expect(Order.find_orders(merchant1)).to eq(expected1)
      expect(Order.find_orders(merchant2)).to eq(expected2)
    end
  end

  describe 'instance methods' do
    before :each do
      Faker::UniqueGenerator.clear

      @user = create(:user)
      @merchant = create(:user, role: 1)

      @item_1, @item_2, @item_3, @item_4, @item_5, @item_6, @item_7, @item_8, @item_9, @item_10 = create_list(:item, 10, user: @merchant)

      @order = create(:order, user: @user)

      @order_item_1 = create(:order_item, item: @item_1, order: @order, sale_price: 5, quantity: 1)
      @order_item_2 = create(:order_item, item: @item_2, order: @order, sale_price: 5, quantity: 2)
      @order_item_3 = create(:order_item, item: @item_3, order: @order, sale_price: 5, quantity: 3)
      @order_item_4 = create(:order_item, item: @item_4, order: @order, sale_price: 5, quantity: 4)
      @order_item_5 = create(:order_item, item: @item_5, order: @order, sale_price: 5, quantity: 5)
      @order_item_6 = create(:order_item, item: @item_6, order: @order, sale_price: 5, quantity: 6)
      @order_item_7 = create(:order_item, item: @item_7, order: @order, sale_price: 5, quantity: 7)
      @order_item_8 = create(:order_item, item: @item_8, order: @order, sale_price: 5, quantity: 8, fulfillment_status: 1)
      @order_item_9 = create(:order_item, item: @item_9, order: @order, sale_price: 5, quantity: 9, fulfillment_status: 1)
      @order_item_10 = create(:order_item, item: @item_10, order: @order, sale_price: 5, quantity: 10, fulfillment_status: 1)
    end

    it '#item_count' do

      expected = OrderItem.sum(:quantity)
      actual = @order.item_count

      expect(actual).to eq(expected)
    end

    it '#total_cost' do
      actual = @order.total_cost

      expect(actual).to eq(275)
    end

    it '#change_status' do

      @order.change_status
      expected = true
      actual = @order.cancelled?

      expect(actual).to eq(expected)
    end

    it '#cancel' do
      @order.cancel

      expect(@order.status).to eq("cancelled")

      @order.order_items.each do |order_item|
        expect(order_item.fulfillment_status).to eq("unfulfilled")
      end
    end

  end

end
