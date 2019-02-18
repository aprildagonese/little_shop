require 'rails_helper'

RSpec.describe "as a visitor" do
  context "visiting merchants_path" do

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

      @merch_1, @merch_2, @merch_3, @merch_4, @merch_5, @merch_6, @merch_7, @merch_8, @merch_9, @merch_10 = create_list(:merchant, 10)
      @merchants = [@merch_1, @merch_2, @merch_3, @merch_4, @merch_5, @merch_6, @merch_7, @merch_8, @merch_9, @merch_10]

      @merch1_item_1, @merch1_item_2 = create_list(:item, 5, user: @merch_1)
      @merch2_item_1, @merch2_item_2  = create_list(:item, 2, user: @merch_2)
      @merch3_item_1, @merch3_item_2  = create_list(:item, 2, user: @merch_3)
      @merch4_item_1, @merch4_item_2  = create_list(:item, 2, user: @merch_4)
      @merch5_item_1, @merch5_item_2  = create_list(:item, 2, user: @merch_5)
      @merch6_item_1, @merch6_item_2 = create_list(:item, 9, user: @merch_7)
      @merch7_item_1 = create_list(:item, 9, user: @merch_6)
      @merch8_item = create_list(:item, 9, user: @merch_8)
      @merch9_item = create_list(:item, 9, user: @merch_8)
      @merch10_item = create_list(:item, 9, user: @merch_8)

      @ma_order_1, @ma_order_2, @ma_order_3 = create_list(:order, 3, user: @ma_user)
      @ca_order_1 = create(:order, user: @ca_user)
      @wi_order_1, @wi_order_2 = create_list(:order, 2, user: @wi_user)
      @co_order_1 = create(:order, user: @co_user)
      @co_order_2, @co_order_3 = create_list(:order, 2, user: @co_user_2)
      @pa_order_1, @pa_order_2 = create_list(:order, 2, user: @pa_user)
      @mi_order_1, @mi_order_2, @mi_order_3, @mi_order_4, @mi_order_5, @mi_order_6 = create_list(:order, 6, user: @mi_user)
      @ny_order_1, @ny_order_2 = create_list(:order, 2, user: @ny_user)
      @il_order_1, @il_order_2, @il_order_3, @il_order_4 = create_list(:order, 4, user: @il_user)

      @ma_orderitem_1 = create(:order_item, order: @ma_order_1, item: @merch1_item_1, quantity: 41, price: 25, created_at: 4000.minutes.ago, updated_at: 1700.minutes.ago)
      @ma_orderitem_2 = create(:order_item, order: @ma_order_1, item: @merch1_item_2, quantity: 21, price: 25, created_at: 4000.minutes.ago, updated_at: 1600.minutes.ago)
      @ma_orderitem_3 = create(:order_item, order: @ma_order_2, item: @merch2_item_1, quantity: 2, price: 4, created_at: 200.minutes.ago, updated_at: 198.minutes.ago)
      @ma_orderitem_4 = create(:order_item, order: @ma_order_3, item: @merch2_item_2, quantity: 4, price: 2, created_at: 5000.minutes.ago, updated_at: 4998.minutes.ago)
      @ma_orderitem_5 = create(:order_item, order: @ma_order_4, item: @merch3_item_1, quantity: 1, price: 1, created_at: 4000.minutes.ago, updated_at: 1000.minutes.ago)

      @ca_orderitem_1 = create(:order_item, user: @ca_order_1, item: @merch3_item_2, quantity: 6, price: 1, created_at: 9001.minutes.ago, updated_at: 4001.minutes.ago)
      @ca_orderitem_2 = create(:order_item, user: @ca_order_1, item: @merch4_item_1, quantity: 3, price: 3, created_at: 12000.minutes.ago, updated_at: 7000.minutes.ago)

      @wi_orderitem_1 = create(:order_item, order: @wi_order_1, item: @merch4_item_2, quantity: 2, price: 2, created_at: 11990.minutes.ago, updated_at: 7000.minutes.ago)
      @wi_orderitem_2 = create(:order_item, order: @wi_order_2, item: @merch5_item_1, quantity: 1, price: 3, created_at: 4000.minutes.ago, updated_at: 1500.minutes.ago)
      @wi_orderitem_3 = create(:order_item, order: @wi_order_2, item: @merch5_item_2, quantity: 4, price: 1, created_at: 4000.minutes.ago, updated_at: 1500.minutes.ago)

      @co_orderitem_1 = create(:order_item, order: @co_order_1, item: @merch6_item_1, quantity: 2, price: 6, created_at: 6000.minutes.ago, updated_at: 200.minutes.ago)

      @co_orderitem_2 = create(:order_item, order: @co_order_2, item: @merch6_item_2, quantity: 1, price: 1, created_at: 12001.minutes.ago, updated_at: 6001.minutes.ago)
      @co_orderitem_3 = create(:order_item, order: @co_order_3, item: @merch7_item, quantity: 322, price: 10, created_at: 1000.minutes.ago, updated_at: 995.minutes.ago)
      @co_orderitem_4 = create(:order_item, order: @co_order_3, item: @merch8_item_1, quantity: 1, price: 1, created_at: 4000.minutes.ago, updated_at: 3955.minutes.ago)
      @co_orderitem_5 = create(:order_item, order: @co_order_3, item: @merch9_item, quantity: 90, price: 60, created_at: 5000.minutes.ago, updated_at: 4900.minutes.ago)
      @co_orderitem_6 = create(:order_item, order: @co_order_3, item: @merch1_item_1, quantity: 35, price: 25, created_at: 4000.minutes.ago, updated_at: 1700.minutes.ago)

      @pa_orderitem_1 = create(:order_item, order: @pa_order_1, item: @merch8_item, quantity: 1, price: 6, created_at: 4000.minutes.ago, updated_at: 3952.minutes.ago)
      @pa_orderitem_2 = create(:order_item, order: @pa_order_2, item: @merch9_item, quantity: 99, price: 60, created_at: 5001.minutes.ago, updated_at: 4900.minutes.ago)

      @mi_orderitem_1 = create(:order_item, order: @mi_order_1, item: @merch1_item_2, quantity: 37, price: 25, created_at: 4000.minutes.ago, updated_at: 1600.minutes.ago)
      @mi_orderitem_2 = create(:order_item, order: @mi_order_2, item: @merch2_item_1, quantity: 3, price: 6, created_at: 5100.minutes.ago, updated_at: 5101.minutes.ago)
      @mi_orderitem_3 = create(:order_item, order: @mi_order_3, item: @merch2_item_2, quantity: 2, price: 8, created_at: 4000.minutes.ago, updated_at: 3999.minutes.ago)
      @mi_orderitem_4 = create(:order_item, order: @mi_order_4, item: @merch3_item_1, quantity: 1, price: 1, created_at: 20000.minutes.ago, updated_at: 18000.minutes.ago)
      @mi_orderitem_5 = create(:order_item, order: @mi_order_5, item: @merch3_item_2, quantity: 4, price: 6, created_at: 20001.minutes.ago, updated_at: 18000.minutes.ago)
      @mi_orderitem_6 = create(:order_item, order: @mi_order_6, item: @merch9_item, quantity: 80, price: 60, created_at: 5000.minutes.ago, updated_at: 4900.minutes.ago)

      @ny_orderitem_1 = create(:order_item, order: @ny_order_1, item: @merch8_item, quantity: 1, price: 1, created_at: 4000.minutes.ago, updated_at: 3950.minutes.ago)
      @ny_orderitem_2 = create(:order_item, order: @ny_order_2, item: @merch9_item, quantity: 88, price: 60, created_at: 5007.minutes.ago, updated_at: 4902.minutes.ago)

      @il_orderitem_1 = create(:order_item, order: @il_order_1, item: @merch9_item, quantity: 24, price: 60, created_at: 5011.minutes.ago, updated_at: 4901.minutes.ago)
      @il_orderitem_2 = create(:order_item, order: @il_order_2, item: @merch4_item_1, quantity: 12, price: 1, created_at: 6000.minutes.ago, updated_at: 300.minutes.ago)
      @il_orderitem_3 = create(:order_item, order: @il_order_3, item: @merch4_item_2, quantity: 2, price: 3, created_at: 5000.minutes.ago, updated_at: 300.minutes.ago)
      @il_orderitem_4 = create(:order_item, order: @il_order_4, item: @merch5_item_1, quantity: 1, price: 2, created_at: 4000.minutes.ago, updated_at: 1500.minutes.ago)

      login_as(@co_user)
      visit merchants_path

    end

    it "it shows a list of all merchants" do

      expect(page).to have_content("All Restaurants")

      @merchants.each do |merchant|
        within ".user-#{merchant.id}-row" do
          expect(page).to have_content("#{merchant.name}")
          expect(page).to have_content("#{merchant.city}")
          expect(page).to have_content("#{merchant.state}")
          expect(page).to have_content("#{merchant.created_at.to_date.to_s}")
        end
      end

    end
    it "shows merchant statistics" do
      # As a visitor
      # When I visit the merchants index page, I see an area with statistics:
      expect(page).to have_content("Statistics")
      within "#peoples-choice" do
        # - top 3 merchants who have sold the most by price and quantity, and their revenue
        # 1. merch 9
        # 2. merch 1
        # 3. merch 7
      end
      within "#fast-food" do
        # - top 3 merchants who were fastest at fulfilling items in an order, and their times
        # 1. merch 2
        # 2. merch 7
        # 3. merch 8

        # 4. merch 9
      end

      within "#slow-food" do
        # - worst 3 merchants who were slowest at fulfilling items in an order, and their times
        # 1. merch 6
        # 2. merch 4
        # 3. merch 3

        # 4. merch 5
        # 5. merch 1
      end

       within "#foodie-states" do
        # - top 3 states where any orders were shipped (by number of orders), and count of orders
        # 1. Michigan
        # 2. Illinois
        # 3. Colorado
       end
       within "#foodie-cities" do
        # - top 3 cities where any orders were shipped (by number of orders, also Springfield, MI should not be grouped with Springfield, CO), and the count of orders
        # 1. Detroit, MI
        # 2. Detroit, IL
        # 3. Boston, MA
       end
       within "biggest-appetites" do
        # - top 3 biggest orders by quantity of items shipped in an order, plus their quantities
        # 1. CO order 3
        # 2. PA order 2
        # 3. NY order 2
       end

    end
  end
end
