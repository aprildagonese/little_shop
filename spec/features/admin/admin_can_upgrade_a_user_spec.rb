require 'rails_helper'

RSpec.describe "As an admin", type: :feature do
  before :each do
    Faker::UniqueGenerator.clear

    @admin = create(:user, role: 2)
    login_as(@admin)
    @user = create(:user, name: "user man", role: 0)
  end

  context "when it visits a user's profile" do
    it 'sees a button to downgrade a merchant to a user that redirects to the admin user show page' do
      visit admin_user_path(@user)

      expect(page).to have_button("Upgrade User")
    end

    context 'clicks the button to downgrade merchant' do
      it 'redirects to an admin user show path and merchant role is now a user' do
        visit admin_merchant_path(@merchant)

        click_button "Upgrade User"

        expect(current_path).to eq(admin_merchant_path(@user)

        expect(page).to have_content("Merchant has been downgraded to a user")
        expect(page).to_not have_button("Downgrade")
      end
    end

  end
end
