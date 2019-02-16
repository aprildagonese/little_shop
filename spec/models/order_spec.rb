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
      cart = {"1"=>1, "2"=>1, "3"=>1}

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
  end

  describe 'instance methods' do
    before :each do
      Faker::UniqueGenerator.clear

      @user = create(:user)
      @merchant = create(:user, role: 1)

      @item_1, @item_2, @item_3, @item_4, @item_5, @item_6, @item_7, @item_8, @item_9, @item_10 = create_list(:item, 10, user: @merchant)

      @order = create(:order, user: @user)

      @order_item_1 = create(:order_item, item: @item_1, order: @order)
      @order_item_2 = create(:order_item, item: @item_2, order: @order)
      @order_item_3 = create(:order_item, item: @item_3, order: @order)
      @order_item_4 = create(:order_item, item: @item_4, order: @order)
      @order_item_5 = create(:order_item, item: @item_5, order: @order)
      @order_item_6 = create(:order_item, item: @item_6, order: @order)
      @order_item_7 = create(:order_item, item: @item_7, order: @order)
      @order_item_8 = create(:order_item, item: @item_8, order: @order)
      @order_item_9 = create(:order_item, item: @item_9, order: @order)
      @order_item_10 = create(:order_item, item: @item_10, order: @order)
    end

    it '#item_count' do

      expected = OrderItem.sum(:quantity)
      actual = @order.item_count

      expect(actual).to eq(expected)
    end

    it '#total_cost' do

      expected = OrderItem.sum(:sale_price)
      actual = @order.total_cost

      expect(actual).to eq(expected)

    end

    it '#change_status' do

      @order.change_status
      expected = true
      actual = @order.cancelled?

      expect(actual).to eq(expected)

    end

  end

end
