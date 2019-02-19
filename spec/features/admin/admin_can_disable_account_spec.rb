require 'rails_helper'

RSpec.describe "As an admin", type: :feature do
  before :each do
    Faker::UniqueGenerator.clear

    @admin = create(:user, role: 2)
    login_as(@admin)

    @user = create(:user)
    @merchant = create(:user, role: 1)
  end

  context 'when it visits the merchants index' do
    #it "it redirects to the admin merchant index, shows a flash message saying they've been disabled, and shows the merchant as disabled" do
    it "it can disable a merchant" do
      visit admin_merchants_path

      click_button "Disable"

      expect(current_path).to eq(admin_merchants_path)
    end
  end

  context 'when it visits the users index' do
    it "it can disable a user" do
      visit admin_users_path

      within ".user-#{@user.id}-row" do
        click_button "Disable"
      end

      expect(current_path).to eq(admin_users_path)
      expect(page).to have_content("User #{@user.name}'s account has been disabled.")

      within ".user-#{@user.id}-row" do
        expect(page).to have_content("#{@user.name} (Disabled)")
        expect(page).to have_button("Enable")
      end

      click_link("Log Out")
      click_link("Log In")

      fill_in "email", with: @user.email
      fill_in "password", with: @user.password
      click_button("Log In")

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Login failed. Please check your email address and password.")
    end
  end
end
