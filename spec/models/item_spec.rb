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
    describe '#avg_fulfillment_time' do
      it 'should get the average fulfillment time for an item' do
        merchant = create(:user, role: 1)
        item_1 = create(:item, user: merchant)
        item_2 = create(:item, user: merchant)
        inactive_item = create(:item, user: merchant, activation_status: "inactive")

        order_1 = create(:order, status: 1)
        order_2 = create(:order, status: 1)
        unfulfilled_order = create(:order, status: 0)
        canceled_order = create(:order, status: 0)

        create(:order_item, item: item_1, order: order_1, sale_price: 5, created_at: 2.days.ago, updated_at: 1.day.ago)
        create(:order_item, item: item_2, order: order_1, sale_price: 5, created_at: 3.days.ago, updated_at: 1.day.ago)
        create(:order_item, item: inactive_item, order: order_1, sale_price: 5, created_at: 4.days.ago, updated_at: 1.day.ago)
        create(:order_item, item: item_1, order: order_2, sale_price: 5, created_at: 6.days.ago, updated_at: 1.day.ago)
        create(:order_item, item: item_1, order: unfulfilled_order, sale_price: 5, created_at: 7.days.ago, updated_at: 1.day.ago)
        create(:order_item, item: item_1, order: canceled_order, sale_price: 5, created_at: 8.days.ago, updated_at: 1.day.ago)

        expect(item_1.fulfillment_time).to eq("3 days, 0 hours")
      end

      it 'should get the average fulfillment time for an item as n/a' do
        merchant = create(:user, role: 1)
        item_1 = create(:item, user: merchant)
        item_2 = create(:item, user: merchant)
        item_3 = create(:item, user: merchant)
        inactive_item = create(:item, user: merchant, activation_status: "inactive")

        order_1 = create(:order, status: 1)
        order_2 = create(:order, status: 1)
        unfulfilled_order = create(:order, status: 0)
        canceled_order = create(:order, status: 0)

        create(:order_item, item: item_1, order: order_1, sale_price: 5, created_at: 2.days.ago, updated_at: 1.day.ago)
        create(:order_item, item: item_2, order: order_1, sale_price: 5, created_at: 3.days.ago, updated_at: 1.day.ago)
        create(:order_item, item: inactive_item, order: order_1, sale_price: 5, created_at: 4.days.ago, updated_at: 1.day.ago)
        create(:order_item, item: item_1, order: order_2, sale_price: 5, created_at: 6.days.ago, updated_at: 1.day.ago)
        create(:order_item, item: item_1, order: unfulfilled_order, sale_price: 5, created_at: 7.days.ago, updated_at: 1.day.ago)
        create(:order_item, item: item_1, order: canceled_order, sale_price: 5, created_at: 8.days.ago, updated_at: 1.day.ago)

        expect(item_3.fulfillment_time).to eq(nil)
      end
    end
  end

  describe "Instance Methods" do
  end
  
end
