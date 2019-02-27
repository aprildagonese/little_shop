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
      it {should validate_presence_of(:email)}
      it {should validate_uniqueness_of(:email)}
      it {should validate_presence_of(:password)}
      it {should validate_presence_of(:slug)}
      it {should validate_uniqueness_of(:slug)}
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
      Faker::UniqueGenerator.clear

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

    it '::total_sales' do

      expected = [9, 13, 31, 32, 50, 3220, 3350, 22868]
      actual = User.total_sales.map do |user|
        user.revenue
      end

      expect(actual).to eq(expected)
    end
  end

  describe "Instance Methods" do

    before :each do
      Faker::UniqueGenerator.clear
    end

    it '#create_slug' do
      user = User.new(name: 'user', email: 'slug<>#%{ }|\^~[_]`;/?:@=&user@test.com', password: 'password', street_address: '123 test st.', city: 'city', zip_code: 00000, state: 'state')
      user.create_slug
      user.save

      expected = User.last
      actual = User.find_by slug: 'slug-user-test-com'

      expect(actual).to eq(expected)
    end

    it "#change_status" do
      user = create(:user,
                    name: "April",
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

    it '#upgrade' do
      user = create(:user, role: 0)

      expect(user.role).to eq("registered")
      user.upgrade
      expect(user.role).to eq("merchant")
    end

    context 'merchant dash stats' do
      before :each do
        Faker::UniqueGenerator.clear
        @merch1, @merch2 = create_list(:user, 2, role: 1)
        @user1 = create(:user, city: "Springfield", state: "IL")
        @user2 = create(:user, city: "Springfield", state: "MO")
        @user3 = create(:user, city: "Chicago", state: "IL")
        @item1, @item2 = create_list(:item, 2, user: @merch1)
        @item3 = create(:item, user: @merch2)
        @order1, @order2 = create_list(:order, 2, user: @user1)
        @order3, @order4, @order5 = create_list(:order, 3, user: @user2)
        @order6 = create(:order, user: @user3)
        @oi1 = create(:fulfilled_order_item, order: @order1, item: @item1, quantity: 1, sale_price: 30)
        @oi2 = create(:order_item, order: @order1, item: @item2, quantity: 2)
        @oi3 = create(:order_item, order: @order1, item: @item3, quantity: 3)
        @oi4 = create(:fulfilled_order_item, order: @order2, item: @item1, quantity: 4, sale_price: 5)
        @oi5 = create(:order_item, order: @order2, item: @item2, quantity: 5)
        @oi6 = create(:order_item, order: @order2, item: @item3, quantity: 6)
        @oi7 = create(:fulfilled_order_item, order: @order3, item: @item1, quantity: 7, sale_price: 10)
        @oi8 = create(:order_item, order: @order3, item: @item2, quantity: 8)
        @oi9 = create(:order_item, order: @order3, item: @item3, quantity: 9)
        @oi10 = create(:fulfilled_order_item, order: @order4, item: @item1, quantity: 10, sale_price: 3)
        @oi11 = create(:order_item, order: @order4, item: @item2, quantity: 11)
        @oi12 = create(:order_item, order: @order4, item: @item3, quantity: 12)
        @oi13 = create(:fulfilled_order_item, order: @order5, item: @item1, quantity: 13, sale_price: 1)
        @oi14 = create(:order_item, order: @order5, item: @item2, quantity: 14)
        @oi15 = create(:order_item, order: @order5, item: @item3, quantity: 15)
        @oi16 = create(:fulfilled_order_item, order: @order6, item: @item1, quantity: 16, sale_price: 2)
      end

      it '#year_chart' do
        Faker::UniqueGenerator.clear
          merchant = create(:merchant)
          item_1, item_2, item_3, item_4 = create_list(:item, 4, user: merchant)
          user_1, user_2, user_3, user_4 = create_list(:user, 4)

          user_1_order_0 = user_1.orders.create(status: :fulfilled, created_at: 2.years.ago, updated_at: 2.years.ago)
          create(:order_item, item: item_1, order: user_1_order_0, created_at: 2.years.ago, updated_at: 2.years.ago, fulfillment_status: :fulfilled, sale_price: 6, quantity: 10)

          user_1_order_1 = user_1.orders.create(status: :fulfilled, created_at: 12.months.ago.end_of_month, updated_at: 12.months.ago.end_of_month)
          user_1_order_2 = user_1.orders.create(status: :fulfilled, created_at: 11.months.ago, updated_at: 11.months.ago)
          user_1_order_3 = user_1.orders.create(status: :fulfilled, created_at: 10.months.ago, updated_at: 10.months.ago)
          create(:order_item, item: item_1, order: user_1_order_1, created_at: 12.months.ago.end_of_month, updated_at: 12.months.ago.end_of_month, fulfillment_status: :fulfilled, sale_price: 10, quantity: 12)
          create(:order_item, item: item_4, order: user_1_order_1, created_at: 12.months.ago.end_of_month, updated_at: 12.months.ago.end_of_month, fulfillment_status: :fulfilled, sale_price: 16, quantity: 18)
          create(:order_item, item: item_2, order: user_1_order_2, created_at: 11.months.ago, updated_at: 11.months.ago, fulfillment_status: :fulfilled, sale_price: 14, quantity: 19)
          create(:order_item, item: item_3, order: user_1_order_3, created_at: 10.months.ago, updated_at: 10.months.ago, fulfillment_status: :fulfilled, sale_price: 5, quantity: 18)

          user_2_order_1 = user_2.orders.create(status: :fulfilled, created_at: 9.months.ago, updated_at: 9.months.ago)
          user_2_order_2 = user_2.orders.create(status: :fulfilled, created_at: 8.months.ago, updated_at: 8.months.ago)
          user_2_order_3 = user_2.orders.create(status: :fulfilled, created_at: 7.months.ago, updated_at: 7.months.ago)
          user_2_order_4 = user_2.orders.create(status: :pending, created_at: 7.months.ago, updated_at: 7.months.ago)
          create(:order_item, item: item_4, order: user_2_order_1, created_at: 9.months.ago, updated_at: 9.months.ago, fulfillment_status: :fulfilled, sale_price: 24, quantity: 18)
          create(:order_item, item: item_1, order: user_2_order_2, created_at: 8.months.ago, updated_at: 8.months.ago, fulfillment_status: :fulfilled, sale_price: 30, quantity: 9)
          create(:order_item, item: item_2, order: user_2_order_3, created_at: 7.months.ago, updated_at: 7.months.ago, fulfillment_status: :fulfilled, sale_price: 17, quantity: 12)
          create(:order_item, item: item_2, order: user_2_order_4, created_at: 7.months.ago, updated_at: 7.months.ago, fulfillment_status: :pending, sale_price: 10, quantity: 8)

          user_3_order_1 = user_3.orders.create(status: :fulfilled, created_at: 6.months.ago, updated_at: 6.months.ago)
          user_3_order_2 = user_3.orders.create(status: :fulfilled, created_at: 5.months.ago, updated_at: 5.months.ago)
          user_3_order_3 = user_3.orders.create(status: :fulfilled, created_at: 4.months.ago, updated_at: 4.months.ago)
          user_3_order_4 = user_3.orders.create(status: :pending, created_at: 4.months.ago, updated_at: 4.months.ago)
          create(:order_item, item: item_3, order: user_3_order_1, created_at: 6.months.ago, updated_at: 6.months.ago, fulfillment_status: :fulfilled, sale_price: 13, quantity: 13)
          create(:order_item, item: item_4, order: user_3_order_2, created_at: 5.months.ago, updated_at: 5.months.ago, fulfillment_status: :fulfilled, sale_price: 40, quantity: 6)
          create(:order_item, item: item_1, order: user_3_order_3, created_at: 4.months.ago, updated_at: 4.months.ago, fulfillment_status: :fulfilled, sale_price: 16, quantity: 32)
          create(:order_item, item: item_1, order: user_3_order_4, created_at: 4.months.ago, updated_at: 4.months.ago, fulfillment_status: :pending, sale_price: 42, quantity: 13)

          user_4_order_1 = user_4.orders.create(status: :fulfilled, created_at: 3.months.ago, updated_at: 3.months.ago)
          user_4_order_2 = user_4.orders.create(status: :fulfilled, created_at: 2.months.ago, updated_at: 2.months.ago)
          user_4_order_3 = user_4.orders.create(status: :fulfilled, created_at: 1.month.ago, updated_at: 1.month.ago)
          create(:order_item, item: item_2, order: user_4_order_1, created_at: 3.months.ago, updated_at: 3.months.ago, fulfillment_status: :fulfilled, sale_price: 20, quantity: 18)
          create(:order_item, item: item_3, order: user_4_order_2, created_at: 2.months.ago, updated_at: 2.months.ago, fulfillment_status: :fulfilled, sale_price: 17, quantity: 8)
          create(:order_item, item: item_4, order: user_4_order_3, created_at: 1.month.ago, updated_at: 1.month.ago, fulfillment_status: :fulfilled, sale_price: 90, quantity: 7)
          create(:order_item, item: item_1, order: user_4_order_3, created_at: 1.month.ago, updated_at: 1.month.ago, fulfillment_status: :fulfilled, sale_price: 16, quantity: 22)
        expected = {
        "Month: 1.0, Year: 2019.0" => 982,
        "Month: 10.0, Year: 2018.0" => 512,
        "Month: 11.0, Year: 2018.0" => 360,
        "Month: 12.0, Year: 2018.0" => 136,
        "Month: 2.0, Year: 2018.0" => 408,
        "Month: 3.0, Year: 2018.0" => 266,
        "Month: 4.0, Year: 2018.0" => 90,
        "Month: 5.0, Year: 2018.0" => 432,
        "Month: 6.0, Year: 2018.0" => 270,
        "Month: 7.0, Year: 2018.0" => 204,
        "Month: 8.0, Year: 2018.0" => 169,
        "Month: 9.0, Year: 2018.0" => 240,
        }
        actual = merchant.year_chart

        expect(actual).to eq(expected)
      end

      it '#inventory_chart' do
        merchant = create(:merchant)

        item_1 = create(:item, user: merchant, quantity: 12)
        item_2 = create(:item, user: merchant, quantity: 12)
        item_3 = create(:item, user: merchant, quantity: 12)
        item_4 = create(:item, user: merchant, quantity: 12)

        order = create(:order, status: 1)
        order_item_1 = create(:order_item, order: order, item: item_1, quantity: 6, fulfillment_status: 1)
        order_item_1 = create(:order_item, order: order, item: item_2, quantity: 6, fulfillment_status: 1)
        order_item_1 = create(:order_item, order: order, item: item_3, quantity: 6, fulfillment_status: 1)
        order_item_1 = create(:order_item, order: order, item: item_4, quantity: 6, fulfillment_status: 1)

        expected = {"items sold"=> 24, "total items"=> 72}
        actual = merchant.inventory_chart

        expect(actual).to eq(expected)
      end

      it '#state_chart' do
        expected = {"IL"=>21, "MO"=>30}
        actual = @merch1.state_chart

        expect(actual).to eq(expected)
      end

      it '#city_chart' do
        expected = {"Chicago, IL"=>16, "Springfield, IL"=>5, "Springfield, MO"=>30}
        actual = @merch1.city_chart

        expect(actual).to eq(expected)
      end

      describe '#yearly_revenue' do
        it 'returns revenue by month for the last 12 months' do
          Faker::UniqueGenerator.clear
          merchant = create(:merchant)
          item_1, item_2, item_3, item_4 = create_list(:item, 4, user: merchant)
          user_1, user_2, user_3, user_4 = create_list(:user, 4)

          user_1_order_0 = user_1.orders.create(status: :fulfilled, created_at: 2.years.ago, updated_at: 2.years.ago)
          create(:order_item, item: item_1, order: user_1_order_0, created_at: 2.years.ago, updated_at: 2.years.ago, fulfillment_status: :fulfilled, sale_price: 6, quantity: 10)

          user_1_order_1 = user_1.orders.create(status: :fulfilled, created_at: 12.months.ago.end_of_month, updated_at: 12.months.ago.end_of_month)
          user_1_order_2 = user_1.orders.create(status: :fulfilled, created_at: 11.months.ago, updated_at: 11.months.ago)
          user_1_order_3 = user_1.orders.create(status: :fulfilled, created_at: 10.months.ago, updated_at: 10.months.ago)
          create(:order_item, item: item_1, order: user_1_order_1, created_at: 12.months.ago.end_of_month, updated_at: 12.months.ago.end_of_month, fulfillment_status: :fulfilled, sale_price: 10, quantity: 12)
          create(:order_item, item: item_4, order: user_1_order_1, created_at: 12.months.ago.end_of_month, updated_at: 12.months.ago.end_of_month, fulfillment_status: :fulfilled, sale_price: 16, quantity: 18)
          create(:order_item, item: item_2, order: user_1_order_2, created_at: 11.months.ago, updated_at: 11.months.ago, fulfillment_status: :fulfilled, sale_price: 14, quantity: 19)
          create(:order_item, item: item_3, order: user_1_order_3, created_at: 10.months.ago, updated_at: 10.months.ago, fulfillment_status: :fulfilled, sale_price: 5, quantity: 18)

          user_2_order_1 = user_2.orders.create(status: :fulfilled, created_at: 9.months.ago, updated_at: 9.months.ago)
          user_2_order_2 = user_2.orders.create(status: :fulfilled, created_at: 8.months.ago, updated_at: 8.months.ago)
          user_2_order_3 = user_2.orders.create(status: :fulfilled, created_at: 7.months.ago, updated_at: 7.months.ago)
          user_2_order_4 = user_2.orders.create(status: :pending, created_at: 7.months.ago, updated_at: 7.months.ago)
          create(:order_item, item: item_4, order: user_2_order_1, created_at: 9.months.ago, updated_at: 9.months.ago, fulfillment_status: :fulfilled, sale_price: 24, quantity: 18)
          create(:order_item, item: item_1, order: user_2_order_2, created_at: 8.months.ago, updated_at: 8.months.ago, fulfillment_status: :fulfilled, sale_price: 30, quantity: 9)
          create(:order_item, item: item_2, order: user_2_order_3, created_at: 7.months.ago, updated_at: 7.months.ago, fulfillment_status: :fulfilled, sale_price: 17, quantity: 12)
          create(:order_item, item: item_2, order: user_2_order_4, created_at: 7.months.ago, updated_at: 7.months.ago, fulfillment_status: :pending, sale_price: 10, quantity: 8)

          user_3_order_1 = user_3.orders.create(status: :fulfilled, created_at: 6.months.ago, updated_at: 6.months.ago)
          user_3_order_2 = user_3.orders.create(status: :fulfilled, created_at: 5.months.ago, updated_at: 5.months.ago)
          user_3_order_3 = user_3.orders.create(status: :fulfilled, created_at: 4.months.ago, updated_at: 4.months.ago)
          user_3_order_4 = user_3.orders.create(status: :pending, created_at: 4.months.ago, updated_at: 4.months.ago)
          create(:order_item, item: item_3, order: user_3_order_1, created_at: 6.months.ago, updated_at: 6.months.ago, fulfillment_status: :fulfilled, sale_price: 13, quantity: 13)
          create(:order_item, item: item_4, order: user_3_order_2, created_at: 5.months.ago, updated_at: 5.months.ago, fulfillment_status: :fulfilled, sale_price: 40, quantity: 6)
          create(:order_item, item: item_1, order: user_3_order_3, created_at: 4.months.ago, updated_at: 4.months.ago, fulfillment_status: :fulfilled, sale_price: 16, quantity: 32)
          create(:order_item, item: item_1, order: user_3_order_4, created_at: 4.months.ago, updated_at: 4.months.ago, fulfillment_status: :pending, sale_price: 42, quantity: 13)

          user_4_order_1 = user_4.orders.create(status: :fulfilled, created_at: 3.months.ago, updated_at: 3.months.ago)
          user_4_order_2 = user_4.orders.create(status: :fulfilled, created_at: 2.months.ago, updated_at: 2.months.ago)
          user_4_order_3 = user_4.orders.create(status: :fulfilled, created_at: 1.month.ago, updated_at: 1.month.ago)
          create(:order_item, item: item_2, order: user_4_order_1, created_at: 3.months.ago, updated_at: 3.months.ago, fulfillment_status: :fulfilled, sale_price: 20, quantity: 18)
          create(:order_item, item: item_3, order: user_4_order_2, created_at: 2.months.ago, updated_at: 2.months.ago, fulfillment_status: :fulfilled, sale_price: 17, quantity: 8)
          create(:order_item, item: item_4, order: user_4_order_3, created_at: 1.month.ago, updated_at: 1.month.ago, fulfillment_status: :fulfilled, sale_price: 90, quantity: 7)
          create(:order_item, item: item_1, order: user_4_order_3, created_at: 1.month.ago, updated_at: 1.month.ago, fulfillment_status: :fulfilled, sale_price: 16, quantity: 22)

          expected = ["Year: 2018.0, Month: 2.0, Revenue: 408",
                      "Year: 2018.0, Month: 3.0, Revenue: 266",
                      "Year: 2018.0, Month: 4.0, Revenue: 90",
                      "Year: 2018.0, Month: 5.0, Revenue: 432",
                      "Year: 2018.0, Month: 6.0, Revenue: 270",
                      "Year: 2018.0, Month: 7.0, Revenue: 204",
                      "Year: 2018.0, Month: 8.0, Revenue: 169",
                      "Year: 2018.0, Month: 9.0, Revenue: 240",
                      "Year: 2018.0, Month: 10.0, Revenue: 512",
                      "Year: 2018.0, Month: 11.0, Revenue: 360",
                      "Year: 2018.0, Month: 12.0, Revenue: 136",
                      "Year: 2019.0, Month: 1.0, Revenue: 982"]
          actual = merchant.yearly_revenue(1).map { |obj| "Year: #{obj.year}, Month: #{obj.month}, Revenue: #{obj.item_revenue}"}

          expect(actual).to eq(expected)
        end
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

      describe '#top_states' do
        it 'shows the top 3 states for that user and their quantities' do
          expected = @merch1.top_states(3)

          expect(expected[0].state).to eq(@user2.state)
          expect(expected[0].total_items).to eq(30)

          expect(expected[1].state).to eq(@user1.state)
          expect(expected[1].total_items).to eq(21)
        end
      end

      describe '#top_city_states' do
        it 'shows the top 3 city, states for that merchant and their quantities' do
          expected = @merch1.top_city_states(3)

          expect(expected[0].city).to eq(@user2.city)
          expect(expected[1].city).to eq(@user3.city)
          expect(expected[2].city).to eq(@user1.city)

          expect(expected[0].total_items).to eq(30)
          expect(expected[1].total_items).to eq(16)
          expect(expected[2].total_items).to eq(5)
        end
      end

      describe '#top_spending_patrons' do
        it 'shows the top 3 city, states for that merchant and their quantities' do
          expected = @merch1.top_spending_patrons(3)

          expect(expected[0].name).to eq(@user2.name)
          expect(expected[1].name).to eq(@user1.name)
          expect(expected[2].name).to eq(@user3.name)

          expect(expected[0].total_spent).to eq(113)
          expect(expected[1].total_spent).to eq(50)
          expect(expected[2].total_spent).to eq(32)
        end
      end

      describe '#most_items_patrons' do
        it 'shows the patron who has purchased the most total items and their quantity of items' do
          expected = @merch1.most_items_patrons(1)

          expect(expected[0].name).to eq(@user2.name)
          expect(expected[0].total_items_qty).to eq(30)
        end
      end

      describe '#most_orders_patrons' do
        it 'shows the patron who has purchased the most total items and their quantity of items' do
          expected = @merch1.most_orders_patrons(1)

          expect(expected[0].name).to eq(@user2.name)
          expect(expected[0].total_orders).to eq(3)
        end
      end

    end
  end
end
