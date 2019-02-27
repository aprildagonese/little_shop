require "rails_helper"

RSpec.describe Item, type: :model do

  before :each do
    Faker::UniqueGenerator.clear
  end

  describe "relationships" do
    it {should have_many :order_items}
    it {should have_many(:orders).through :order_items}
    it {should belong_to :user}
  end

  describe 'Validations' do
    describe 'Required Field(s)' do
      it {should validate_presence_of(:title)}
      it {should validate_uniqueness_of(:title)}
      it {should validate_presence_of(:description)}
      it {should validate_presence_of(:quantity)}
      it {should validate_presence_of(:price)}
      it {should validate_presence_of(:slug)}
      it {should validate_uniqueness_of(:slug)}

    end
  end

  describe 'Class Methods' do
    context "sorting by quantity fulfilled" do
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

    context ".top_items_sold" do
      it "should sort by highest item sold first" do
        Faker::UniqueGenerator.clear
        @merchant = create(:user, role: 1)
        @user1, @user2, @user3, @user4, @user5, @user6, @user7 = create_list(:user, 7, role: 0)
        @item1, @item2, @item3, @item4, @item5, @item6, @item7 = create_list(:item, 7, user: @merchant, quantity: 10)
        @order1 = create(:order, user: @user1)
        @order2 = create(:order, user: @user2)
        @order3 = create(:order, user: @user3)
        @order4 = create(:order, user: @user4)
        @order5 = create(:order, user: @user5)
        @order6 = create(:order, user: @user6)
        @order7 = create(:order, user: @user7)
        @oi1 = create(:order_item, order: @order1, item: @item1, quantity: 2)
        @oi2 = create(:order_item, order: @order2, item: @item2, quantity: 4)
        @oi3 = create(:order_item, order: @order3, item: @item3, quantity: 6)
        @oi4 = create(:order_item, order: @order4, item: @item4, quantity: 7)
        @oi5 = create(:order_item, order: @order5, item: @item5, quantity: 5)
        @oi6 = create(:order_item, order: @order6, item: @item6, quantity: 3)
        @oi7 = create(:order_item, order: @order7, item: @item7, quantity: 1)

        expected = [@item4, @item3, @item5, @item2, @item6, @item1, @item7]

        expect(Item.top_items_sold(@merchant)).to eq(expected)
      end
    end

    context ".total_sold_quantity" do
      it "should get merchant's sum of all quantities fulfilled for all items" do
        merch1, merch2 = create_list(:user, 2, role: 1)
        user1, user2, user3 = create_list(:user, 3)
        item1, item2 = create_list(:item, 2, user: merch1)
        item3 = create(:item, user: merch2)
        order1, order2 = create_list(:order, 2, user: user1)
        order3, order4 = create_list(:order, 2, user: user2)
        order5 = create(:order, user: user3)
        oi1 = create(:order_item, order: order1, item: item1, quantity: 1, fulfillment_status: 0)
        oi2 = create(:order_item, order: order1, item: item2, quantity: 2, fulfillment_status: 1)
        oi3 = create(:order_item, order: order1, item: item3, quantity: 3, fulfillment_status: 1)
        oi4 = create(:order_item, order: order2, item: item1, quantity: 4, fulfillment_status: 1)
        oi5 = create(:order_item, order: order2, item: item2, quantity: 5, fulfillment_status: 1)
        oi6 = create(:order_item, order: order2, item: item3, quantity: 6, fulfillment_status: 1)
        oi7 = create(:order_item, order: order3, item: item1, quantity: 7, fulfillment_status: 1)
        oi8 = create(:order_item, order: order3, item: item2, quantity: 8, fulfillment_status: 1)
        oi9 = create(:order_item, order: order3, item: item3, quantity: 9, fulfillment_status: 0)
        oi10 = create(:order_item, order: order4, item: item1, quantity: 10, fulfillment_status: 1)
        oi11 = create(:order_item, order: order4, item: item2, quantity: 11, fulfillment_status: 1)
        oi12 = create(:order_item, order: order4, item: item3, quantity: 12, fulfillment_status: 1)
        oi13 = create(:order_item, order: order5, item: item1, quantity: 13, fulfillment_status: 1)
        oi14 = create(:order_item, order: order5, item: item2, quantity: 14, fulfillment_status: 1)
        oi15 = create(:order_item, order: order5, item: item3, quantity: 15, fulfillment_status: 1)

        expected1 = (oi2.quantity + oi4.quantity + oi5.quantity + oi7.quantity + oi8.quantity + oi10.quantity + oi11.quantity + oi13.quantity + oi14.quantity)
        expected2 = (oi3.quantity + oi6.quantity + oi12.quantity + oi15.quantity)

        expect(Item.total_sold_quantity(merch1)).to eq(expected1)
        expect(Item.total_sold_quantity(merch2)).to eq(expected2)
      end
    end

    context ".total_inventory" do
      it "should get merchant's sum of all quantities of all items sold or in stock" do
        user1 = create(:user)
        merch1, merch2, merch3 = create_list(:user, 3, role: 1)
        item1, item2 = create_list(:item, 2, user: merch1, quantity: 20)
        item3, item4 = create_list(:item, 2, user: merch2, quantity: 22)
        item5, item6, item7 = create_list(:item, 3, user: merch3, quantity: 13)
        order1 = create(:order, user: user1)
        create(:order_item, order: order1, item: item1, quantity: 1, fulfillment_status: 1)
        create(:order_item, order: order1, item: item2, quantity: 2, fulfillment_status: 1)
        create(:order_item, order: order1, item: item3, quantity: 3, fulfillment_status: 1)
        create(:order_item, order: order1, item: item4, quantity: 4, fulfillment_status: 1)
        create(:order_item, order: order1, item: item5, quantity: 5, fulfillment_status: 1)
        create(:order_item, order: order1, item: item6, quantity: 6, fulfillment_status: 1)
        create(:order_item, order: order1, item: item7, quantity: 7, fulfillment_status: 1)

        expected1 = 43
        expected2 = 51
        expected3 = 57

        expect(Item.total_inventory(merch1)).to eq(expected1)
        expect(Item.total_inventory(merch2)).to eq(expected2)
        expect(Item.total_inventory(merch3)).to eq(expected3)
      end
    end

    context ".percent_sold" do
      it "should get merchant's sum of all quantities of all items sold or in stock" do
        user1 = create(:user)
        merch1, merch2, merch3 = create_list(:user, 3, role: 1)
        item1, item2 = create_list(:item, 2, user: merch1, quantity: 20)
        item3, item4 = create_list(:item, 2, user: merch2, quantity: 22)
        item5, item6, item7 = create_list(:item, 3, user: merch3, quantity: 13)
        order1 = create(:order, user: user1)
        create(:order_item, order: order1, item: item1, quantity: 1, fulfillment_status: 1)
        create(:order_item, order: order1, item: item2, quantity: 2, fulfillment_status: 1)
        create(:order_item, order: order1, item: item3, quantity: 3, fulfillment_status: 1)
        create(:order_item, order: order1, item: item4, quantity: 4, fulfillment_status: 1)
        create(:order_item, order: order1, item: item5, quantity: 5, fulfillment_status: 1)
        create(:order_item, order: order1, item: item6, quantity: 6, fulfillment_status: 1)
        create(:order_item, order: order1, item: item7, quantity: 7, fulfillment_status: 1)

        sold1 = 3.0
        inventory1 = 43.0
        expected1 = ((sold1/inventory1)*100).round(2)

        sold2 = 7.0
        inventory2 = 51.0
        expected2 = ((sold2/inventory2)*100).round(2)

        sold3 = 18.0
        inventory3 = 57.0
        expected3 = ((sold3/inventory3)*100).round(2)

        expect(Item.percent_sold(merch1)).to eq(expected1)
        expect(Item.percent_sold(merch2)).to eq(expected2)
        expect(Item.percent_sold(merch3)).to eq(expected3)
      end

      it "should show 'N/A' if a percentage is not yet available" do
        user1 = create(:user)
        merch1, merch2, merch3 = create_list(:user, 3, role: 1)
        item1, item2 = create_list(:item, 2, user: merch1, quantity: 20)
        item3, item4 = create_list(:item, 2, user: merch2, quantity: 22)
        item5, item6, item7 = create_list(:item, 3, user: merch3, quantity: 13)
        order1 = create(:order, user: user1)
        create(:order_item, order: order1, item: item1, quantity: 1, fulfillment_status: 0)
        create(:order_item, order: order1, item: item2, quantity: 2, fulfillment_status: 0)
        create(:order_item, order: order1, item: item3, quantity: 3, fulfillment_status: 0)
        create(:order_item, order: order1, item: item4, quantity: 4, fulfillment_status: 0)
        create(:order_item, order: order1, item: item5, quantity: 5, fulfillment_status: 0)
        create(:order_item, order: order1, item: item6, quantity: 6, fulfillment_status: 0)
        create(:order_item, order: order1, item: item7, quantity: 7, fulfillment_status: 0)

        expect(Item.percent_sold(merch1)).to eq("N/A")
        expect(Item.percent_sold(merch2)).to eq("N/A")
        expect(Item.percent_sold(merch3)).to eq("N/A")
      end
    end
  end

  describe "Instance Methods" do

    it '#create_slug' do
      merchant = create(:merchant)
      item = merchant.items.new(title: 'food<glorious>#%{ }|\^~[_]`;/?:@=&food', description: 'desc', quantity: 12, price: 12)
      # item.create_slug
      item.save

      expected = Item.last
      actual = Item.find_by slug: 'food-glorious-food'

      expect(actual).to eq(expected)
    end

    describe '#ordered?' do
      it 'should return true if that item has been ordered' do
        item = create(:item)
        order = create(:order)
        create(:order_item, order: order, item: item)

        expected = true
        actual = item.ordered?

        expect(actual).to eq(expected)
      end

      it 'should return false if that item has not been ordered' do
        item = create(:item)

        expected = false
        actual = item.ordered?

        expect(actual).to eq(expected)
      end
    end

    describe '#avg_fulfillment_time' do
      it 'should get the average fulfillment time for an item' do
        merchant = create(:user, role: 1)
        item_1 = create(:item, user: merchant)
        item_2 = create(:item, user: merchant)
        inactive_item = create(:item, user: merchant, active: false)

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
        inactive_item = create(:item, user: merchant, active: false)

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

      it "#units_sold should return quantity sold for an item" do
        Faker::UniqueGenerator.clear
        merch = create(:user, role: 1)
        user1, user2 = create_list(:user, 2)
        item1, item2 = create_list(:item, 2, user: merch)
        order1, order2 = create_list(:order, 2, user: user1)
        order3, order4 = create_list(:order, 2, user: user2)
        create(:order_item, order: order1, item: item1, quantity: 1)
        create(:order_item, order: order1, item: item2, quantity: 2)
        create(:order_item, order: order2, item: item1, quantity: 3)
        create(:order_item, order: order2, item: item2, quantity: 4)
        create(:order_item, order: order3, item: item1, quantity: 5)
        create(:order_item, order: order3, item: item2, quantity: 6)
        create(:order_item, order: order4, item: item1, quantity: 7)
        create(:order_item, order: order4, item: item2, quantity: 8)

        expect(item1.units_sold).to eq(16)
        expect(item2.units_sold).to eq(20)
      end
    end

    it "#change_status" do
      merchant = create(:merchant)
      item = create(:item,
                    title: "Test",
                    description: "dish",
                    quantity: 5,
                    price: 5,
                    user: merchant,
                    active: true)
      expect(item.active).to eq(true)
      item.change_status
      expect(item.active).to eq(false)
      item.change_status
      expect(item.active).to eq(true)
    end
  end

end
