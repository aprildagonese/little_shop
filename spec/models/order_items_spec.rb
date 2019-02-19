require "rails_helper"

RSpec.describe OrderItem, type: :model do
  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
  end

  describe 'Validations' do
    # it {should validate_presence_of(:quantity)}
    it {should validate_presence_of(:sale_price)}
  end

  describe 'Class Methods' do
  end

  describe "Instance Methods" do
    it "#calculates a subtotal" do
      user = create(:user)
      order = create(:order, user: user)
      item1 = create(:item)
      item2 = create(:item)
      oi1 = create(:order_item, order: order, item: item1, sale_price: 5, quantity: 3)
      oi2 = create(:order_item, order: order, item: item2, sale_price: 3, quantity: 2)

      expect(oi1.subtotal).to eq(15)
      expect(oi2.subtotal).to eq(6)
    end

    it "#cancel_item" do
      user = create(:user)
      merchant = create(:user, role: 1)
      order = create(:order, user: user, status: 0)
      item1 = create(:item, user: merchant, quantity: 5)
      item2 = create(:item, user: merchant, quantity: 5)
      oi1 = create(:order_item, order: order, item: item1, sale_price: 5, quantity: 3, fulfillment_status: 0)
      oi2 = create(:order_item, order: order, item: item2, sale_price: 3, quantity: 2, fulfillment_status: 1)

      oi1.cancel_item

      expect(oi1.fulfillment_status).to eq("unfulfilled")
      expect(oi1.quantity).to eq(3)
      expect(item1.quantity).to eq(5)

      oi2.cancel_item

      expect(oi2.fulfillment_status).to eq("unfulfilled")
      expect(oi2.quantity).to eq(2)
      expect(item2.quantity).to eq(7)

    end

    it '#in_stock?' do
      Faker::UniqueGenerator.clear
      @user = create(:user)
      @merchant = create(:user, role: 1)
      @item_1, @item_2, @item_3, @item_4, @item_5, @item_6, @item_7, @item_8, @item_9, @item_10 = create_list(:item, 10, user: @merchant, quantity: 5)
      @order = create(:order, user: @user)
      @order_item_1 = create(:order_item, item: @item_1, order: @order, sale_price: 5, quantity: 1)
      @order_item_2 = create(:order_item, item: @item_2, order: @order, sale_price: 5, quantity: 2)
      @order_item_3 = create(:order_item, item: @item_3, order: @order, sale_price: 5, quantity: 7)
      @order_item_4 = create(:order_item, item: @item_4, order: @order, sale_price: 5, quantity: 4)
      @order_item_5 = create(:order_item, item: @item_5, order: @order, sale_price: 5, quantity: 5)
      @order_item_6 = create(:order_item, item: @item_6, order: @order, sale_price: 5, quantity: 6)
      @order_item_7 = create(:order_item, item: @item_7, order: @order, sale_price: 5, quantity: 3)
      @order_item_8 = create(:order_item, item: @item_8, order: @order, sale_price: 5, quantity: 8, fulfillment_status: 1)
      @order_item_9 = create(:order_item, item: @item_9, order: @order, sale_price: 5, quantity: 9, fulfillment_status: 1)
      @order_item_10 = create(:order_item, item: @item_10, order: @order, sale_price: 5, quantity: 10, fulfillment_status: 1)

      expect(@order_item_1.in_stock?).to eq(true)
      expect(@order_item_2.in_stock?).to eq(true)
      expect(@order_item_3.in_stock?).to eq(false)
      expect(@order_item_4.in_stock?).to eq(true)
      expect(@order_item_5.in_stock?).to eq(true)
      expect(@order_item_6.in_stock?).to eq(false)
      expect(@order_item_7.in_stock?).to eq(true)
      expect(@order_item_8.in_stock?).to eq(false)
      expect(@order_item_9.in_stock?).to eq(false)
      expect(@order_item_10.in_stock?).to eq(false)
    end
  end

end
