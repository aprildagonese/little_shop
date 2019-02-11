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
  end

end
