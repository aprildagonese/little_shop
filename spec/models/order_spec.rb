require 'rails_helper'

describe Order, type: :model do

  describe 'relationships' do
    it {should have_many :order_items}
    it {should have_many(:items).through :order_items}
    it {should belong_to :user}
  end

  describe 'validations' do
  end

  describe 'class methods' do
    it "::generate_order" do
      item1 = create(:item)
      item2 = create(:item)
      item3 = create(:item)
      cart = {"1"=>1, "2"=>1, "3"=>1}

      expect(Order.count).to eq(0)
      expect(OrderItem.count).to eq(0)

      Order.generate_order(cart)
      order = Order.last

      expect(Order.count).to eq(1)
      expect(OrderItem.count).to eq(3)
      expect(order.order_items[0].item).to eq(item1)
      expect(order.order_items[1].item).to eq(item2)
      expect(order.order_items[2].item).to eq(item3)
    end
  end

  describe 'instance methods' do
  end

end
