require 'rails_helper'

RSpec.describe "as a merchant" do
  context "when I visit my Dashboard" do
    it "I see my profile data" do
      merchant = create(:user, role: 1)
      login_as(merchant)

      visit dashboard_path(merchant)

      expect(page).to have_content("Name: #{merchant.name}")
      expect(page).to have_content("Address: #{merchant.street_address}")
      expect(page).to have_content("City: #{merchant.city}")
      expect(page).to have_content("State: #{merchant.state}")
      expect(page).to have_content("Zip Code: #{merchant.zip_code}")
      expect(page).to have_content("Email: #{merchant.email}")
      expect(page).to_not have_button("Edit Profile")
      expect(page).to_not have_button("Downgrade Merchant")
    end

    it "it shows me orders with unfulfilled items" do
      Faker::UniqueGenerator.clear
      merchant1, merchant2 = create_list(:user, 2, role: 1)
      user1, user2 = create_list(:user, 2, role: 0)
      item1, item2 = create_list(:item, 2, user: merchant1)
      item3, item4 = create_list(:item, 2, user: merchant2)
      order1 = create(:order, user: user1)
      order2 = create(:order, user: user2)
      order3 = create(:order, user: user1)
      oi1 = create(:order_item, order: order1, item: item1)
      oi2 = create(:order_item, order: order1, item: item3)
      oi3 = create(:order_item, order: order2, item: item2, status: 1)
      oi4 = create(:order_item, order: order2, item: item4)
      oi5 = create(:order_item, order: order3, item: item1)
      oi6 = create(:order_item, order: order3, item: item2, status: 1)

      login_as(merchant1)
      visit dashboard_path(merchant1)

      within "#order-#{order1.id}" do
        expect(page).to have_link("#{order1.id}", href: profile_order_path(order1))
        expect(page).to have_content("Placed on: #{order1.created_at.to_date.to_s}")
        expect(page).to have_content("Item Count: #{order1.item_count}")
        expect(page).to have_content("Order Total: #{order1.total_cost}")
      end
      within "#order-#{order3.id}" do
        expect(page).to have_link("#{order3.id}", href: profile_order_path(order3))
        expect(page).to have_content("Placed on: #{order3.created_at.to_date.to_s}")
        expect(page).to have_content("Item Count: #{order3.item_count}")
        expect(page).to have_content("Order Total: #{order3.total_cost}")
      end
      expect(page).to_not have_button("Cancel Order")
      expect(page).to_not have_link("#{order2.id}", href: profile_order_path(order2))
    end
  end

  context "my Dashboard shows me statistics on" do
    before :each do
      Faker::UniqueGenerator.clear
      @merchant = create(:user, role: 1)
      @user1, @user2, @user3, @user4, @user5, @user6, @user7 = create_list(:user, 7, role: 0)
      @item1, @item2, @item3, @item4, @item5, @item6, @item7 = create_list(:item, 7, user: @merchant, quantity: 10)
      @order1 = create(:order, user: @user1)
      @order2 = create(:order, user: @user2)
      @order3 = create(:order, user: @user3)
      @order4 = create(:order, user: @user4)
      @order5 = create(:order, user: @user4)
      @order6 = create(:order, user: @user4)
      @order7 = create(:order, user: @user7)
      @oi1 = create(:order_item, order: @order1, item: @item1, quantity: 1)
      @oi2 = create(:order_item, order: @order2, item: @item2, quantity: 2)
      @oi3 = create(:order_item, order: @order3, item: @item3, quantity: 3)
      @oi4 = create(:order_item, order: @order4, item: @item4, quantity: 4)
      @oi5 = create(:order_item, order: @order5, item: @item5, quantity: 5)
      @oi6 = create(:order_item, order: @order6, item: @item6, quantity: 6)
      @oi7 = create(:order_item, order: @order7, item: @item7, quantity: 7)

      login_as(@merchant)
      visit dashboard_path(@merchant)
    end

    it "top 5 items sold by quantity" do
      expect(page).to have_content("#{@item7.title}: #{@item7.units_sold} units sold")
      expect(page).to have_content("#{@item6.title}: #{@item6.units_sold} units sold")
      expect(page).to have_content("#{@item5.title}: #{@item5.units_sold} units sold")
      expect(page).to have_content("#{@item4.title}: #{@item4.units_sold} units sold")
      expect(page).to have_content("#{@item3.title}: #{@item3.units_sold} units sold")
    end

    it "total quantity of items sold" do
      expect(page).to have_content("Sold #{Item.total_sold_quantity(@merchant)} items, which is #{Item.percent_sold(@merchant)}% of your total inventory")
    end

    it "the user with the most orders from me" do
      expect(page).to have_content("User With Most Orders: #{@user4.name} (#{@user4.orders.count} orders placed)")
    end
  end
end
