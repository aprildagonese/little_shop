require 'rails_helper'

RSpec.describe "As an admin", type: :feature do
  before :each do
    @admin = create(:user, role: 2)
    login_as(@admin)
    @merchant = create(:user, role: 1)
  end

  context "when it visits a merchant's dashboard" do
    it 'sees a button to downgrade a merchant to a user that redirects to the admin user show page' do
      visit admin_merchant_path(@merchant)

      expect(page).to have_button("Downgrade Merchant")
    end

    context 'clicks the button to downgrade merchant' do
      it 'redirects to a admin user show path and merchant role is now a user' do
        visit admin_merchant_path(@merchant)
        
        click_button "Downgrade Merchant"

        expect(current_path).to eq(admin_user_path(@merchant))

        expect(page).to have_content("Merchant has been downgraded to a user")
      end
    end
  end
end
