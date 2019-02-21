require 'rails_helper'

RSpec.describe "As an admin", type: :feature do
  before :each do
    Faker::UniqueGenerator.clear

    @admin = create(:user, role: 2)
    login_as(@admin)

    @merchant = create(:merchant)
  end

  context 'when it visits the merchant index page' do
    it "can click on a merchant's name and is take to the admin merchant show page" do
      visit admin_merchants_path

      click_link @merchant.name

      expect(current_path).to eq(admin_merchant_path(@merchant))
      expect(page).to have_content("Name: #{@merchant.name}")
      expect(page).to have_content("Address: #{@merchant.street_address}")
      expect(page).to have_content("City: #{@merchant.city}")
      expect(page).to have_content("State: #{@merchant.state}")
      expect(page).to have_content("Zip Code: #{@merchant.zip_code}")
      expect(page).to have_content("Email: #{@merchant.email}")
      expect(page).to have_button("Edit Profile")
      expect(page).to have_button("Downgrade Merchant")
    end

    it "can click on a merchant's name and is take to the admin merchant show page" do
      Faker::UniqueGenerator.clear
      merchant2 = create(:user, role: 1)
      user1, user2 = create_list(:user, 2, role: 0)
      item1, item2 = create_list(:item, 2, user: @merchant)
      item3, item4 = create_list(:item, 2, user: merchant2)
      order1 = create(:order, user: user1)
      order2 = create(:order, user: user2)
      order3 = create(:order, user: user1, status: 1)
      create(:order_item, order: order1, item: item1, sale_price: 2.00, quantity: 1)
      create(:order_item, order: order1, item: item3, sale_price: 3.00, quantity: 1)
      create(:order_item, order: order2, item: item2, fulfillment_status: 1)
      create(:order_item, order: order2, item: item4, fulfillment_status: 1)
      create(:order_item, order: order3, item: item1, sale_price: 4.00, quantity: 1)
      create(:order_item, order: order3, item: item2, fulfillment_status: 1, sale_price: 5.00, quantity: 1)

      visit admin_merchants_path

      click_link @merchant.name

      expect(page).to have_content("Merchant #{@merchant.id} Orders")

      within "#order-#{order1.id}" do
        expect(page).to have_link("Order ID: #{order1.id}")
        expect(page).to have_content("Placed on: #{order1.created_at.to_date.to_s}")
        expect(page).to have_content("Item Count: #{order1.item_count}")
        expect(page).to have_content("Order Total: $#{order1.total_cost}")
        expect(page).to have_button("Cancel Order")
      end
      within "#order-#{order3.id}" do
        expect(page).to have_link("Order ID: #{order3.id}")
        expect(page).to have_content("Placed on: #{order3.created_at.to_date.to_s}")
        expect(page).to have_content("Item Count: #{order3.item_count}")
        expect(page).to have_content("Order Total: $#{order3.total_cost}")
        expect(page).to_not have_button("Cancel Order")
      end
      expect(page).to_not have_content("Order ID: #{order2.id}")
    end

  end
end
