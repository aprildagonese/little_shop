require 'rails_helper'

RSpec.describe "As an admin" do
  context "I can fulfill an item on behalf of a merchant" do
    it "by changing the oi status and reducing the item's quantity" do
      Faker::UniqueGenerator.clear
      user = create(:user, name: "Zach")
      merchant = create(:user, role: 1, name: "Peregrine")
      merchant2 = create(:user, role: 1, name: "Scott")
      admin = create(:user, role: 2, name: "April")
      order = create(:order, user: user)
      i1, i3, i5 = create_list(:item, 3, user: merchant, quantity: 5)
      i2, i4 = create_list(:item, 2, user: merchant2, quantity: 5)
      oi1 = create(:order_item, item: i1, order: order, quantity: 5)
      oi2 = create(:order_item, item: i2, order: order, quantity: 5, fulfillment_status: 1)
      oi3 = create(:order_item, item: i3, order: order, quantity: 3)
      oi4 = create(:order_item, item: i4, order: order, quantity: 3)
      oi5 = create(:order_item, item: i5, order: order, quantity: 6)

      login_as(admin)
      visit admin_merchant_order_path(order: order, merchant: merchant)

      within ".item-#{oi1.id}" do
        expect(page).to have_content("Order Item Status: Pending")
        click_button "Fulfill Item"
        expect(page).to have_content("Order Item Status: Fulfilled")
      end

      expect(page).to_not have_content("#{oi2.item.title}")

      within ".item-#{oi3.id}" do
        expect(page).to have_content("Order Item Status: Pending")
        click_button "Fulfill Item"
        expect(page).to have_content("Order Item Status: Fulfilled")
      end

      expect(page).to_not have_content("#{oi4.item.title}")

      within ".item-#{oi5.id}" do
        expect(page).to have_content("Order Item Status: Pending")
        expect(page).to_not have_button("Fulfill Item")
        expect(page).to have_content("You have insufficient quantity in stock to fulfill this order item.")
      end

      visit admin_merchant_order_path(order, merchant: merchant2)

      expect(page).to_not have_content("#{oi1.item.title}")

      within ".item-#{oi2.id}" do
        expect(page).to have_content("Order Item Status: Fulfilled")
        expect(page).to_not have_button("Fulfill Item")
      end

      expect(page).to_not have_content("#{oi3.item.title}")

      within ".item-#{oi4.id}" do
        expect(page).to have_content("Order Item Status: Pending")
        click_button "Fulfill Item"
        expect(page).to have_content("Order Item Status: Fulfilled")
      end
    end
  end
end
