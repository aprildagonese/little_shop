require "rails_helper"

RSpec.describe Item, type: :model do
  describe "relationships" do
    it {should have_many :order_items}
    it {should have_many(:orders).through :order_items}
    it {should belong_to :user}
  end

  describe 'Validations' do
    describe 'Required Field(s)' do
      it {should validate_presence_of(:title)}
      it {should validate_presence_of(:description)}
      it {should validate_presence_of(:quantity)}
      it {should validate_presence_of(:price)}
    end
  end

  describe 'Class Methods' do
  end

  describe "Instance Methods" do
    describe '.subtotal' do
      it 'should get the total price for an item' do
        item_1 = create(:item, price: 20, quantity: 5)
        item_2 = create(:item, price: 1, quantity: 10)

        expect(item_1.subtotal).to eq(100)
        expect(item_2.subtotal).to eq(10)
      end
    end
  end
end
