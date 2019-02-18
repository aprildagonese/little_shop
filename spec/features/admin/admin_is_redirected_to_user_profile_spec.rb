require 'rails_helper'

RSpec.describe "As an admin", type: :feature do
  before :each do
    @admin = create(:user, role: 2)
    login_as(@admin)

    @user = create(:user, id: 200)
  end

  context 'if it visits a merchant dashboard, but that merchant is a regular user' do
    it 'redirects to a user profile page path' do
      visit admin_merchant_path(@user)

      expect(current_path).to eq(admin_user_path(@user))

      within ".profile" do
        expect(page).to have_content("Name: #{updated_user.name}")
        expect(page).to have_content("Address: #{updated_user.street_address}")
        expect(page).to have_content("City: #{updated_user.city}")
        expect(page).to have_content("State: #{updated_user.state}")
        expect(page).to have_content("Zip Code: #{updated_user.zip_code}")
        expect(page).to have_content("Email: #{updated_user.email}")
      end
    end
  end
end
