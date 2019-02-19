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
    it "calculates a subtotal" do
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
  end

end
