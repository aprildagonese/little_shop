require "rails_helper"

RSpec.describe User, type: :model do

  before :each do
    Faker::UniqueGenerator.clear
  end

  describe "relationships" do
    it {should have_many :items}
  end

  describe 'Validations' do
    describe 'Required Field(s)' do
      it {should validate_presence_of(:name)}
      it {should validate_uniqueness_of(:name)}
      it {should validate_presence_of(:email)}
      it {should validate_uniqueness_of(:email)}
      it {should validate_presence_of(:password)}
    end
  end

  describe 'Roles' do
    it "can be created as an admin" do
      user = User.create(name: "april",
                         password: "test",
                         role: 2)

      expect(user.role).to eq("admin")
      expect(user.admin?).to be_truthy
      expect(user.merchant?).to eq(false)
      expect(user.registered?).to eq(false)
    end

    it "can be created as a merchant" do
      user = User.create(name: "peregrine",
                         password: "test",
                         role: 1)

      expect(user.role).to eq("merchant")
      expect(user.merchant?).to be_truthy
      expect(user.admin?).to eq(false)
      expect(user.registered?).to eq(false)
    end

    it "can be created as a registered user" do
      user = User.create(name: "scott",
                         password: "test",
                         role: 0)

      expect(user.role).to eq("registered")
      expect(user.registered?).to be_truthy
      expect(user.merchant?).to eq(false)
      expect(user.admin?).to eq(false)
    end
  end


  describe 'Class Methods' do

    before :each do
      @ma_user = create(:user, city: 'Boston', state: 'Massachusetts')
      @ca_user = create(:user, city: 'San Francisco', state: 'California')
      @wi_user = create(:user, city: 'Milwaukee', state: 'Wisconsin')
      @co_user = create(:user, city: 'Golden', state: 'Colorado')
      @co_user_2 = create(:user, city: 'Denver', state: 'Colorado')
      @pa_user = create(:user, city: 'Pittsburgh', state: 'Pennsylvania' )
      @mi_user = create(:user, city: 'Detroit', state: 'Michigan')
      @ny_user = create(:user, city: 'Schenectady', state: 'New York')
      @il_user = create(:user, city: 'Detroit', state: 'Illinois')

      @merch_1, @merch_2, @merch_3, @merch_4, @merch_5, @merch_6, @merch_7, @merch_8, @merch_9, @merch_10 = create_list(:merchant, 10, state: 'na')
      @merchants = [@merch_1, @merch_2, @merch_3, @merch_4, @merch_5, @merch_6, @merch_7, @merch_8, @merch_9, @merch_10]

      @merch1_item_1, @merch1_item_2 = create_list(:item, 5, user: @merch_1)
      @merch2_item_1, @merch2_item_2 = create_list(:item, 2, user: @merch_2)
      @merch3_item_1, @merch3_item_2 = create_list(:item, 2, user: @merch_3)
      @merch4_item_1, @merch4_item_2 = create_list(:item, 2, user: @merch_4)
      @merch5_item_1, @merch5_item_2 = create_list(:item, 2, user: @merch_5)
      @merch6_item_1, @merch6_item_2 = create_list(:item, 2, user: @merch_7)
      @merch7_item = create(:item, user: @merch_6)
      @merch8_item = create(:item, user: @merch_8)
      @merch9_item = create(:item, user: @merch_8)
      @merch10_item = create(:item, user: @merch_8)

      @ma_order_1, @ma_order_2, @ma_order_3 = create_list(:order, 3, user: @ma_user, status: 1)
      @ca_order_1 = create(:order, user: @ca_user, status: 1)
      @wi_order_1, @wi_order_2 = create_list(:order, 2, user: @wi_user, status: 1)
      @co_order_1, @co_order_4 = create_list(:order, 2, user: @co_user, status: 1)
      @co_order_2, @co_order_3 = create_list(:order, 2, user: @co_user_2, status: 1)
      @pa_order_1, @pa_order_2 = create_list(:order, 2, user: @pa_user, status: 1)
      @mi_order_1, @mi_order_2, @mi_order_3, @mi_order_4, @mi_order_5, @mi_order_6 = create_list(:order, 6, user: @mi_user, status: 1)
      @ny_order_1, @ny_order_2 = create_list(:order, 2, user: @ny_user, status: 1)
      @il_order_1, @il_order_2, @il_order_3, @il_order_4 = create_list(:order, 4, user: @il_user, status: 1)

      @ma_orderitem_1 = create(:order_item, order: @ma_order_1, item: @merch1_item_1, quantity: 41, sale_price: 25, created_at: 4000.minutes.ago, updated_at: 1700.minutes.ago)
      @ma_orderitem_2 = create(:order_item, order: @ma_order_1, item: @merch1_item_2, quantity: 21, sale_price: 25, created_at: 4000.minutes.ago, updated_at: 1600.minutes.ago)
      @ma_orderitem_3 = create(:order_item, order: @ma_order_2, item: @merch2_item_1, quantity: 2, sale_price: 4, created_at: 200.minutes.ago, updated_at: 198.minutes.ago)
      @ma_orderitem_4 = create(:order_item, order: @ma_order_3, item: @merch2_item_2, quantity: 4, sale_price: 2, created_at: 5000.minutes.ago, updated_at: 4998.minutes.ago)

      @ca_orderitem_1 = create(:order_item, order: @ca_order_1, item: @merch3_item_2, quantity: 6, sale_price: 1, created_at: 9001.minutes.ago, updated_at: 4001.minutes.ago)
      @ca_orderitem_2 = create(:order_item, order: @ca_order_1, item: @merch4_item_1, quantity: 3, sale_price: 3, created_at: 12000.minutes.ago, updated_at: 7000.minutes.ago)

      @wi_orderitem_1 = create(:order_item, order: @wi_order_1, item: @merch4_item_2, quantity: 2, sale_price: 2, created_at: 11990.minutes.ago, updated_at: 7000.minutes.ago)
      @wi_orderitem_2 = create(:order_item, order: @wi_order_2, item: @merch5_item_1, quantity: 1, sale_price: 3, created_at: 4000.minutes.ago, updated_at: 1500.minutes.ago)
      @wi_orderitem_3 = create(:order_item, order: @wi_order_2, item: @merch5_item_2, quantity: 4, sale_price: 1, created_at: 4000.minutes.ago, updated_at: 1500.minutes.ago)

      @co_orderitem_1 = create(:order_item, order: @co_order_1, item: @merch6_item_1, quantity: 2, sale_price: 6, created_at: 6000.minutes.ago, updated_at: 200.minutes.ago)

      @co_orderitem_2 = create(:order_item, order: @co_order_2, item: @merch6_item_2, quantity: 1, sale_price: 1, created_at: 12001.minutes.ago, updated_at: 6001.minutes.ago)
      @co_orderitem_3 = create(:order_item, order: @co_order_3, item: @merch7_item, quantity: 322, sale_price: 10, created_at: 1000.minutes.ago, updated_at: 995.minutes.ago)
      @co_orderitem_4 = create(:order_item, order: @co_order_3, item: @merch8_item, quantity: 1, sale_price: 1, created_at: 4000.minutes.ago, updated_at: 3955.minutes.ago)
      @co_orderitem_5 = create(:order_item, order: @co_order_3, item: @merch9_item, quantity: 90, sale_price: 60, created_at: 5000.minutes.ago, updated_at: 4900.minutes.ago)
      @co_orderitem_6 = create(:order_item, order: @co_order_3, item: @merch1_item_1, quantity: 35, sale_price: 25, created_at: 4000.minutes.ago, updated_at: 1700.minutes.ago)
      @co_orderitem_7 = create(:order_item, order: @co_order_4, item: @merch3_item_1, quantity: 1, sale_price: 1, created_at: 4000.minutes.ago, updated_at: 1000.minutes.ago)

      @pa_orderitem_1 = create(:order_item, order: @pa_order_1, item: @merch8_item, quantity: 1, sale_price: 6, created_at: 4000.minutes.ago, updated_at: 3952.minutes.ago)
      @pa_orderitem_2 = create(:order_item, order: @pa_order_2, item: @merch9_item, quantity: 99, sale_price: 60, created_at: 5001.minutes.ago, updated_at: 4900.minutes.ago)

      @mi_orderitem_1 = create(:order_item, order: @mi_order_1, item: @merch1_item_2, quantity: 37, sale_price: 25, created_at: 4000.minutes.ago, updated_at: 1600.minutes.ago)
      @mi_orderitem_2 = create(:order_item, order: @mi_order_2, item: @merch2_item_1, quantity: 3, sale_price: 6, created_at: 5100.minutes.ago, updated_at: 5101.minutes.ago)
      @mi_orderitem_3 = create(:order_item, order: @mi_order_3, item: @merch2_item_2, quantity: 2, sale_price: 8, created_at: 4000.minutes.ago, updated_at: 3999.minutes.ago)
      @mi_orderitem_4 = create(:order_item, order: @mi_order_4, item: @merch3_item_1, quantity: 1, sale_price: 1, created_at: 20000.minutes.ago, updated_at: 18000.minutes.ago)
      @mi_orderitem_5 = create(:order_item, order: @mi_order_5, item: @merch3_item_2, quantity: 4, sale_price: 6, created_at: 20001.minutes.ago, updated_at: 18000.minutes.ago)
      @mi_orderitem_6 = create(:order_item, order: @mi_order_6, item: @merch9_item, quantity: 80, sale_price: 60, created_at: 5000.minutes.ago, updated_at: 4900.minutes.ago)

      @ny_orderitem_1 = create(:order_item, order: @ny_order_1, item: @merch8_item, quantity: 1, sale_price: 1, created_at: 4000.minutes.ago, updated_at: 3950.minutes.ago)
      @ny_orderitem_2 = create(:order_item, order: @ny_order_2, item: @merch9_item, quantity: 88, sale_price: 60, created_at: 5007.minutes.ago, updated_at: 4902.minutes.ago)

      @il_orderitem_1 = create(:order_item, order: @il_order_1, item: @merch9_item, quantity: 24, sale_price: 60, created_at: 5011.minutes.ago, updated_at: 4901.minutes.ago)
      @il_orderitem_2 = create(:order_item, order: @il_order_2, item: @merch4_item_1, quantity: 12, sale_price: 1, created_at: 6000.minutes.ago, updated_at: 300.minutes.ago)
      @il_orderitem_3 = create(:order_item, order: @il_order_3, item: @merch4_item_2, quantity: 2, sale_price: 3, created_at: 5000.minutes.ago, updated_at: 300.minutes.ago)
      @il_orderitem_4 = create(:order_item, order: @il_order_4, item: @merch5_item_1, quantity: 1, sale_price: 2, created_at: 4000.minutes.ago, updated_at: 1500.minutes.ago)
    end

    it '::highest_revenues' do
      expected = [@merch_8, @merch_1, @merch_6]
      actual = User.highest_revenues

      expect(actual).to eq(expected)
    end

    it '::fastest_fulfillments' do
      expected = [@merch_2, @merch_6, @merch_8]
      actual = User.fastest_fulfillments

      expect(actual).to eq(expected)
    end

    it '::slowest_fulfillments' do
      expected = [@merch_7, @merch_4, @merch_3]
      actual = User.slowest_fulfillments

      expect(actual).to eq(expected)
    end

    it '::most_orders_by_state' do
      expected = [{"Michigan" => 6}, {"Illinois" => 4}, {"Colorado" => 4}]
      actual = User.most_orders_by_state.map do |user|
        {user.state => user.total_orders.to_i}
      end

      expect(actual).to eq(expected)
    end

    it '::most_orders_by_city' do
      expected = [{"Detroit, Michigan" => 6},
      {"Detroit, Illinois"  => 4},
      {"Boston, Massachusetts" => 3}]

      actual = User.most_orders_by_city.map do |user|
        {"#{user.city}, #{user.state}" => user.total_orders.to_i}
      end

      expect(actual).to eq(expected)
    end

  end

  describe "Instance Methods" do

    xit ".user_by_most_orders" do
      Faker::UniqueGenerator.clear
      merchant1, merchant2, merchant3 = create_list(:user, 3, role: 1)
      user1, user2, user3 = create_list(:user, 3, role: 0)
      item1, item2, item3 = create_list(:item, 3, user: merchant1)
      item4, item5 = create_list(:item, 2, user: merchant2)
      item6, item7 = create_list(:item, 2, user: merchant3)

      order1 = create(:order, user: user1) #user1 orders from merch1
      oi1 = create(:order_item, order: order1, item: item1, fulfillment_status: 1)

      order2 = create(:order, user: user2) #user2 orders from both
      oi2 = create(:order_item, order: order2, item: item3, fulfillment_status: 1)
      oi3 = create(:order_item, order: order2, item: item5, fulfillment_status: 1)

      order3 = create(:order, user: user2) #user2 orders from both
      oi4 = create(:order_item, order: order3, item: item2)
      oi5 = create(:order_item, order: order3, item: item4, fulfillment_status: 1)

      order4 = create(:order, user: user1) #user1 orders from merch1
      oi5 = create(:order_item, order: order4, item: item1)
      oi6 = create(:order_item, order: order4, item: item2)

      order5 = create(:order, user: user2) #user2 orders from merch2
      oi7 = create(:order_item, order: order5, item: item4)
      oi8 = create(:order_item, order: order5, item: item5, fulfillment_status: 1)

      order6 = create(:order, user: user2) #user1 orders from merch1
      oi7 = create(:order_item, order: order6, item: item1)
      oi8 = create(:order_item, order: order6, item: item2, fulfillment_status: 1)

      order7 = create(:order, user: user3)
      oi9 = create(:order_item, order: order7, item: item6, fulfillment_status: 1)
      oi10 = create(:order_item, order: order7, item: item7, fulfillment_status: 0)

      expect(User.user_by_most_orders(merchant1)).to eq(user1)
      expect(User.user_by_most_orders(merchant2)).to eq(user2)
      expect(User.user_by_most_orders(merchant3)).to eq(user3)
    end
  end

  describe "Instance Methods" do
    before :each do
      Faker::UniqueGenerator.clear
    end

    it "#change_status" do
      user = User.create!(name: "April",
                          email: "adag@email.com",
                          password: "password",
                          activation_status: 0)
      user.change_status
      expect(user.activation_status).to eq("inactive")
      user.change_status
      expect(user.activation_status).to eq("active")
    end

    it '#downgrade' do
      merchant = create(:user, role: 1)
      item_1 = create(:item, active: true)
      item_2 = create(:item, active: true)
      item_3 = create(:item, active: true)
      merchant.items << item_1
      merchant.items << item_2
      merchant.items << item_3

      expect(merchant.role).to eq("merchant")
      expect(item_1.active).to eq(true)
      expect(item_2.active).to eq(true)
      expect(item_3.active).to eq(true)
      merchant.downgrade
      expect(merchant.role).to eq("registered")
      expect(item_1.active).to eq(false)
      expect(item_2.active).to eq(false)
      expect(item_3.active).to eq(false)
    end

    describe "#total_sold_quantity" do
      it "should get merchant's sum of all quantities sold for all items" do
        merch1, merch2 = create_list(:user, 2, role: 1)
        user1, user2, user3 = create_list(:user, 3)
        item1, item2 = create_list(:item, 2, user: merch1)
        item3 = create(:item, user: merch2)
        order1, order2 = create_list(:order, 2, user: user1)
        order3, order4 = create_list(:order, 2, user: user2)
        order5 = create(:order, user: user3)
        oi1 = create(:order_item, order: order1, item: item1, quantity: 1)
        oi2 = create(:order_item, order: order1, item: item2, quantity: 2)
        oi3 = create(:order_item, order: order1, item: item3, quantity: 3)
        oi4 = create(:order_item, order: order2, item: item1, quantity: 4)
        oi5 = create(:order_item, order: order2, item: item2, quantity: 5)
        oi6 = create(:order_item, order: order2, item: item3, quantity: 6)
        oi7 = create(:order_item, order: order3, item: item1, quantity: 7)
        oi8 = create(:order_item, order: order3, item: item2, quantity: 8)
        oi9 = create(:order_item, order: order3, item: item3, quantity: 9)
        oi10 = create(:order_item, order: order4, item: item1, quantity: 10)
        oi11 = create(:order_item, order: order4, item: item2, quantity: 11)
        oi12 = create(:order_item, order: order4, item: item3, quantity: 12)
        oi13 = create(:order_item, order: order5, item: item1, quantity: 13)
        oi14 = create(:order_item, order: order5, item: item2, quantity: 14)
        oi15 = create(:order_item, order: order5, item: item3, quantity: 15)

        expected1 = (oi1.quantity + oi2.quantity + oi4.quantity + oi5.quantity + oi7.quantity + oi8.quantity + oi10.quantity + oi11.quantity + oi13.quantity + oi14.quantity)
        expected2 = (oi3.quantity + oi6.quantity + oi9.quantity + oi12.quantity + oi15.quantity)

        expect(Item.total_sold_quantity(merch1)).to eq(expected1)
        expect(Item.total_sold_quantity(merch2)).to eq(expected2)
      end
    end


  end
end
