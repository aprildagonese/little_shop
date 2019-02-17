require 'rails_helper'

RSpec.describe "as a merchant" do
  context "when I visit my /dashboard" do
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
    end

    it "it shows me unfulfilled orders" do
      Faker::UniqueGenerator.clear
      merchant1, merchant2 = create_list(:user, 2, role: 1)
      user1, user2 = create_list(:user, 2, role: 0)
      item1, item2 = create_list(:item, 2, user: merchant1)
      item3, item4 = create_list(:item, 2, user: merchant2)
      order1 = create(:order, user: user1)
      order2 = create(:order, user: user2)
      oi1 = create(:order_item, order: order1, item: item1)
      oi2 = create(:order_item, order: order1, item: item3)
      oi3 = create(:order_item, order: order2, item: item2)
      oi4 = create(:order_item, order: order2, item: item4)

      login_as(merchant1)
      visit dashboard_path(merchant1)
      save_and_open_page
      within ".order-#{order1.id}" do
        expect(page).to have_content("Order ID: #{order1.id}")
        expect(page).to have_content("Placed on: #{order1.created_at.to_date.to_s}")
        expect(page).to have_content("Item Count: #{order1.item_count}")
        expect(page).to have_content("Order Total: #{order1.total_cost}")
      end
      within ".order-#{order2.id}" do
        expect(page).to have_content("Order ID: #{order2.id}")
        expect(page).to have_content("Placed on: #{order2.created_at.to_date.to_s}")
        expect(page).to have_content("Item Count: #{order2.item_count}")
        expect(page).to have_content("Order Total: #{order2.total_cost}")
      end
      expect(page).to_not have_button("Cancel Order")
    end
  end
end
