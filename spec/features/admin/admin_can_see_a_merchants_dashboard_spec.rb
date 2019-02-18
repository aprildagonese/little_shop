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
      visit merchants_path
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
  end
end
