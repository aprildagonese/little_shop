require 'rails_helper'

RSpec.describe "site nav bar", type: :feature do

  describe "on the items index page" do
    it "visitor sees a nav bar" do
      visit items_path

      within ".general-nav" do
        expect(page).to have_link("Home")
        expect(page).to have_link("Browse Dishes")
        expect(page).to have_link("Restaurants")
      end
      within ".auth-nav" do
        expect(page).to have_link("Log In")
        expect(page).to have_link("Register")
      end
      within ".cart-nav" do
        expect(page).to have_link("Cart")
      end
    end

    it "visitor cannot see pages without permission" do
      visit profile_path
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit profile_edit_path
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit profile_orders_path
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit dashboard_path
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit admin_dashboard_path
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit admin_items_path
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit admin_merchants_path
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end

  end

end
