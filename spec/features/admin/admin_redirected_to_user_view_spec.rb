require 'rails_helper'

RSpec.describe "As an admin", type: :feature do
  before :each do
    Faker::UniqueGenerator.clear

    @admin = create(:user, role: 2)
    login_as(@admin)

    @user = create(:user, id: 200)
    @merchant = create(:user, id: 201, role: 1)
  end

  context 'if it visits a merchant dashboard, but that merchant is a regular user' do
    it 'redirects to a user profile page path' do
      visit admin_merchant_path(@user)

      expect(current_path).to eq(admin_user_path(@user))

      within ".profile" do
        expect(page).to have_content("Name: #{@user.name}")
        expect(page).to have_content("Address: #{@user.street_address}")
        expect(page).to have_content("City: #{@user.city}")
        expect(page).to have_content("State: #{@user.state}")
        expect(page).to have_content("Zip Code: #{@user.zip_code}")
        expect(page).to have_content("Email: #{@user.email}")
      end
    end
  end

  context 'if it visits a user profile, but that user is a merchant' do
    it 'redirects to merchant dashboard' do
      visit admin_user_path(@merchant)

      expect(current_path).to eq(admin_merchant_path(@merchant))

      within ".profile" do
        expect(page).to have_content("Name: #{@merchant.name}")
        expect(page).to have_content("Address: #{@merchant.street_address}")
        expect(page).to have_content("City: #{@merchant.city}")
        expect(page).to have_content("State: #{@merchant.state}")
        expect(page).to have_content("Zip Code: #{@merchant.zip_code}")
        expect(page).to have_content("Email: #{@merchant.email}")
      end
    end
  end
end
