require 'rails_helper'

RSpec.describe "as a merchant" do
  before :each do
    Faker::UniqueGenerator.clear
    @user = create(:user)
    @merchant = create(:user, role: 1)
    @merchant_2 = create(:user, role: 1)
    @order = create(:order, user: @user)
    @i1, @i2, @i3 = create_list(:item, 3, user: @merchant, quantity: 10, price: 5)
    @i4, @i5 = create_list(:item, 2, user: @merchant_2, quantity: 10, price: 5)
    @oi1, @oi2, @oi3, @oi4, @oi5 = create_list(:order_item, 5)
    @oi1.update(order: @order, item: @i1, sale_price: 2, quantity: 5)
    @oi2.update(order: @order, item: @i2, sale_price: 3, quantity: 5, fulfillment_status: 1)
    @oi3.update(order: @order, item: @i3, sale_price: 4, quantity: 5)
    @oi4.update(order: @order, item: @i4, sale_price: 5, quantity: 5)
    @oi5.update(order: @order, item: @i5, sale_price: 6, quantity: 5)
    @order_items = [@oi1, @oi2, @oi3, @oi4, @oi5]

    login_as(@merchant)
    visit dashboard_order_path(@order)
  end

  context "if the item has already been fulfilled" do
    it "it is listed as fulfilled" do
      within ".item-#{@oi1.id}" do
        expect(page).to have_button("Fulfill Item")
      end
      within ".item-#{@oi2.id}" do
        expect(page).to_not have_button("Fulfill Item")
      end
      within ".item-#{@oi3.id}" do
        expect(page).to have_button("Fulfill Item")
      end
    end
  end
  context "when I have enough in-stock quantity" do
    it 'I can fulfill an order-item' do

    end
  end
  context "if I do not have enough quantity" do
    it "I do something else" do
    end
  end
end



#       When I visit an order show page from my dashboard
# For each item of mine in the order
# If the user's desired quantity is equal to or less than my current inventory quantity for that item
# And I have not already "fulfilled" that item:
# - Then I see a button or link to "fulfill" that item
# - When I click on that link or button I am returned to the order show page
# - I see the item is now fulfilled
# - I also see a flash message indicating that I have fulfilled that item
# - My inventory quantity is permanently reduced by the user's desired quantity
#If I have already fulfilled this item, I see text indicating such.
