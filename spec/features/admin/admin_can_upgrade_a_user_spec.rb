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
      visit admin_user_path(slug: @user.slug)

      expect(page).to have_button("Upgrade User")
    end

    context 'clicks the button to upgrade user' do
      it 'redirects to an admin merchant show path and user role is now a merchant' do
        visit admin_user_path(slug: @user.slug)

        click_button "Upgrade User"

        expect(current_path).to eq(admin_merchant_path(@user.slug))

        expect(page).to have_content("User has been upgraded to a merchant")
        expect(page).to_not have_button("Upgrade")
      end
    end

    it 'no longer shows the newly upgraded user on the user index and they appear on the merchant index page instead' do
      visit admin_users_path
      expect(page).to have_content(@user.name)

      visit admin_merchants_path
      expect(page).to_not have_content(@user.name)

      visit admin_user_path(slug: @user.slug)
      click_button "Upgrade User"

      visit admin_users_path
      expect(page).to_not have_content(@user.name)

      visit admin_merchants_path
      expect(page).to have_content(@user.name)
    end

    it 'shows the newly upgraded user as a merchant when they log in the next time' do
      visit admin_user_path(slug: @user.slug)
      click_button "Upgrade User"

      click_link "Log Out"
      login_as(@user)

      expect(page).to have_content("My Dashboard")
    end
  end
end
