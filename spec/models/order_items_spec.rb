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
  end

end
