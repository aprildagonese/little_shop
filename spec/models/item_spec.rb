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
    before :each do
      Faker::UniqueGenerator.clear

      user_1 = create(:user, role: 1)
      user_2 = create(:user, role: 1)
      @i1, @i2, @i3, @i4 = create_list(:item, 4, user: user_1)
      @i5, @i6, @i7, @i8 = create_list(:item, 4, user: user_2)
      order_1 = create(:order, status: 1)
      order_2 = create(:order, status: 1)
      order_3 = create(:order, status: 0)

      create(:order_item, item: @i1, order: order_1, quantity: 8, sale_price: 5)
      create(:order_item, item: @i2, order: order_2, quantity: 7, sale_price: 5)
      create(:order_item, item: @i3, order: order_1, quantity: 6, sale_price: 5)
      create(:order_item, item: @i4, order: order_2, quantity: 5, sale_price: 5)
      create(:order_item, item: @i5, order: order_1, quantity: 4, sale_price: 5)
      create(:order_item, item: @i6, order: order_2, quantity: 3, sale_price: 5)
      create(:order_item, item: @i7, order: order_1, quantity: 2, sale_price: 5)
      create(:order_item, item: @i8, order: order_3, quantity: 100, sale_price: 5)
      create(:order_item, item: @i4, order: order_1, quantity: 10, sale_price: 5)
      create(:order_item, item: @i5, order: order_2, quantity: 10, sale_price: 5)
    end

    describe '.most_popular' do
      it 'should order items by quanitity fulfilled' do
        expect(Item.most_popular).to eq([@i4, @i5, @i1, @i2, @i3, @i6, @i7])
      end
    end

    describe '.least_popular' do
      it 'should order items by quanitity fulfilled' do
        expect(Item.least_popular).to eq([@i7, @i6, @i3, @i2, @i1, @i5, @i4])
      end
    end

  end

  describe "Instance Methods" do
    describe '.subtotal' do
    end

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
