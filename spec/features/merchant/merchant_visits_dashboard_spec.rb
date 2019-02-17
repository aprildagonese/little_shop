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
      expect(page).to_not have_button("Downgrade Merchant")
    end
  end
end
