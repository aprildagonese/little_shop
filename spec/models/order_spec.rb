require 'rails_helper'

RSpec.describe Order, type: :model do
  before :each do
    Faker::UniqueGenerator.clear
  end

  describe 'relationships' do
    it {should have_many :order_items}
    it {should have_many(:items).through :order_items}
    it {should belong_to :user}
  end

  describe 'validations' do
  end

  describe 'class methods' do

    it '::largest_orders' do
      ma_user = create(:user, city: 'Boston', state: 'Massachusetts')
      ca_user = create(:user, city: 'San Francisco', state: 'California')
      wi_user = create(:user, city: 'Milwaukee', state: 'Wisconsin')
      co_user = create(:user, city: 'Golden', state: 'Colorado')
      co_user_2 = create(:user, city: 'Denver', state: 'Colorado')
      pa_user = create(:user, city: 'Pittsburgh', state: 'Pennsylvania' )
      mi_user = create(:user, city: 'Detroit', state: 'Michigan')
      ny_user = create(:user, city: 'Schenectady', state: 'New York')
      il_user = create(:user, city: 'Detroit', state: 'Illinois')

      merch_1, merch_2, merch_3, merch_4, merch_5, merch_6, merch_7, merch_8, merch_9, merch_10 = create_list(:merchant, 10)
      merchants = [merch_1, merch_2, merch_3, merch_4, merch_5, merch_6, merch_7, merch_8, merch_9, merch_10]

      merch1_item_1, merch1_item_2 = create_list(:item, 5, user: merch_1)
      merch2_item_1, merch2_item_2 = create_list(:item, 2, user: merch_2)
      merch3_item_1, merch3_item_2 = create_list(:item, 2, user: merch_3)
      merch4_item_1, merch4_item_2 = create_list(:item, 2, user: merch_4)
      merch5_item_1, merch5_item_2 = create_list(:item, 2, user: merch_5)
      merch6_item_1, merch6_item_2 = create_list(:item, 2, user: merch_7)
      merch7_item = create(:item, user: merch_6)
      merch8_item = create(:item, user: merch_8)
      merch9_item = create(:item, user: merch_8)
      merch10_item = create(:item, user: merch_8)

      ma_order_1, ma_order_2, ma_order_3 = create_list(:order, 3, user: ma_user, status: 1)
      ca_order_1 = create(:order, user: ca_user, status: 1)
      wi_order_1, wi_order_2 = create_list(:order, 2, user: wi_user, status: 1)
      co_order_1, co_order_4 = create_list(:order, 2, user: co_user, status: 1)
      co_order_2, co_order_3 = create_list(:order, 2, user: co_user_2, status: 1)
      pa_order_1, pa_order_2 = create_list(:order, 2, user: pa_user, status: 1)
      mi_order_1, mi_order_2, mi_order_3, mi_order_4, mi_order_5, mi_order_6 = create_list(:order, 6, user: mi_user, status: 1)
      ny_order_1, ny_order_2 = create_list(:order, 2, user: ny_user, status: 1)
      il_order_1, il_order_2, il_order_3, il_order_4 = create_list(:order, 4, user: il_user, status: 1)

      ma_orderitem_1 = create(:order_item, order: ma_order_1, item: merch1_item_1, quantity: 41, sale_price: 25, created_at: 4000.minutes.ago, updated_at: 1700.minutes.ago)
      ma_orderitem_2 = create(:order_item, order: ma_order_1, item: merch1_item_2, quantity: 21, sale_price: 25, created_at: 4000.minutes.ago, updated_at: 1600.minutes.ago)
      ma_orderitem_3 = create(:order_item, order: ma_order_2, item: merch2_item_1, quantity: 2, sale_price: 4, created_at: 200.minutes.ago, updated_at: 198.minutes.ago)
      ma_orderitem_4 = create(:order_item, order: ma_order_3, item: merch2_item_2, quantity: 4, sale_price: 2, created_at: 5000.minutes.ago, updated_at: 4998.minutes.ago)

      ca_orderitem_1 = create(:order_item, order: ca_order_1, item: merch3_item_2, quantity: 6, sale_price: 1, created_at: 9001.minutes.ago, updated_at: 4001.minutes.ago)
      ca_orderitem_2 = create(:order_item, order: ca_order_1, item: merch4_item_1, quantity: 3, sale_price: 3, created_at: 12000.minutes.ago, updated_at: 7000.minutes.ago)

      wi_orderitem_1 = create(:order_item, order: wi_order_1, item: merch4_item_2, quantity: 2, sale_price: 2, created_at: 11990.minutes.ago, updated_at: 7000.minutes.ago)
      wi_orderitem_2 = create(:order_item, order: wi_order_2, item: merch5_item_1, quantity: 1, sale_price: 3, created_at: 4000.minutes.ago, updated_at: 1500.minutes.ago)
      wi_orderitem_3 = create(:order_item, order: wi_order_2, item: merch5_item_2, quantity: 4, sale_price: 1, created_at: 4000.minutes.ago, updated_at: 1500.minutes.ago)

      co_orderitem_1 = create(:order_item, order: co_order_1, item: merch6_item_1, quantity: 2, sale_price: 6, created_at: 6000.minutes.ago, updated_at: 200.minutes.ago)

      co_orderitem_2 = create(:order_item, order: co_order_2, item: merch6_item_2, quantity: 1, sale_price: 1, created_at: 12001.minutes.ago, updated_at: 6001.minutes.ago)
      co_orderitem_3 = create(:order_item, order: co_order_3, item: merch7_item, quantity: 322, sale_price: 10, created_at: 1000.minutes.ago, updated_at: 995.minutes.ago)
      co_orderitem_4 = create(:order_item, order: co_order_3, item: merch8_item, quantity: 1, sale_price: 1, created_at: 4000.minutes.ago, updated_at: 3955.minutes.ago)
      co_orderitem_5 = create(:order_item, order: co_order_3, item: merch9_item, quantity: 90, sale_price: 60, created_at: 5000.minutes.ago, updated_at: 4900.minutes.ago)
      co_orderitem_6 = create(:order_item, order: co_order_3, item: merch1_item_1, quantity: 35, sale_price: 25, created_at: 4000.minutes.ago, updated_at: 1700.minutes.ago)
      co_orderitem_7 = create(:order_item, order: co_order_4, item: merch3_item_1, quantity: 1, sale_price: 1, created_at: 4000.minutes.ago, updated_at: 1000.minutes.ago)

      pa_orderitem_1 = create(:order_item, order: pa_order_1, item: merch8_item, quantity: 1, sale_price: 6, created_at: 4000.minutes.ago, updated_at: 3952.minutes.ago)
      pa_orderitem_2 = create(:order_item, order: pa_order_2, item: merch9_item, quantity: 99, sale_price: 60, created_at: 5001.minutes.ago, updated_at: 4900.minutes.ago)

      mi_orderitem_1 = create(:order_item, order: mi_order_1, item: merch1_item_2, quantity: 37, sale_price: 25, created_at: 4000.minutes.ago, updated_at: 1600.minutes.ago)
      mi_orderitem_2 = create(:order_item, order: mi_order_2, item: merch2_item_1, quantity: 3, sale_price: 6, created_at: 5100.minutes.ago, updated_at: 5101.minutes.ago)
      mi_orderitem_3 = create(:order_item, order: mi_order_3, item: merch2_item_2, quantity: 2, sale_price: 8, created_at: 4000.minutes.ago, updated_at: 3999.minutes.ago)
      mi_orderitem_4 = create(:order_item, order: mi_order_4, item: merch3_item_1, quantity: 1, sale_price: 1, created_at: 20000.minutes.ago, updated_at: 18000.minutes.ago)
      mi_orderitem_5 = create(:order_item, order: mi_order_5, item: merch3_item_2, quantity: 4, sale_price: 6, created_at: 20001.minutes.ago, updated_at: 18000.minutes.ago)
      mi_orderitem_6 = create(:order_item, order: mi_order_6, item: merch9_item, quantity: 80, sale_price: 60, created_at: 5000.minutes.ago, updated_at: 4900.minutes.ago)

      ny_orderitem_1 = create(:order_item, order: ny_order_1, item: merch8_item, quantity: 1, sale_price: 1, created_at: 4000.minutes.ago, updated_at: 3950.minutes.ago)
      ny_orderitem_2 = create(:order_item, order: ny_order_2, item: merch9_item, quantity: 88, sale_price: 60, created_at: 5007.minutes.ago, updated_at: 4902.minutes.ago)

      il_orderitem_1 = create(:order_item, order: il_order_1, item: merch9_item, quantity: 24, sale_price: 60, created_at: 5011.minutes.ago, updated_at: 4901.minutes.ago)
      il_orderitem_2 = create(:order_item, order: il_order_2, item: merch4_item_1, quantity: 12, sale_price: 1, created_at: 6000.minutes.ago, updated_at: 300.minutes.ago)
      il_orderitem_3 = create(:order_item, order: il_order_3, item: merch4_item_2, quantity: 2, sale_price: 3, created_at: 5000.minutes.ago, updated_at: 300.minutes.ago)
      il_orderitem_4 = create(:order_item, order: il_order_4, item: merch5_item_1, quantity: 1, sale_price: 2, created_at: 4000.minutes.ago, updated_at: 1500.minutes.ago)

      expected = [{co_order_3.id => co_order_3.item_count},
      {pa_order_2.id => pa_order_2.item_count},
      {ny_order_2.id => ny_order_2.item_count}]
      actual = Order.largest_orders.map do |order|
        {order.id => order.total_quantity}
      end

      expect(actual).to eq(expected)
    end

    it "::generate_order" do
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

    it "::find_orders" do
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

      @item_1, @item_2, @item_3, @item_4, @item_5, @item_6, @item_7, @item_8, @item_9, @item_10 = create_list(:item, 10, user: @merchant, quantity: 5)

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
