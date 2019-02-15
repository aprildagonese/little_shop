require 'rails_helper'

describe Order, type: :model do

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

  describe 'relationships' do
    it {should have_many :order_items}
    it {should have_many(:items).through :order_items}
    it {should belong_to :user}
  end

  describe 'validations' do
  end

  describe 'class methods' do
  end

  describe 'instance methods' do

    it '#item_count' do

      expected = 10
      actual = @order.item_count

      expect(actual).to eq(expected)
    end

    it '#total_cost' do

      expected = OrderItem.sum(:sale_price)
      actual = @order.total_cost

      expect(actual).to eq(expected)

    end

  end

end
