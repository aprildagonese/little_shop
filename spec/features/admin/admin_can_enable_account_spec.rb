require 'rails_helper'

RSpec.describe "As an admin", type: :feature do
  before :each do
    Faker::UniqueGenerator.clear

    @admin = create(:user, role: 2)
    @user = create(:user, activation_status: 1)
    @merchant1 = create(:merchant, activation_status: 1)
    @merchant2, @merchant3 = create_list(:user, 2, role: 1)
  end

  context 'when it visits the merchants index' do
    it "it can enable a merchant" do
      login_as(@admin)

      visit admin_merchants_path

      within ".user-#{@merchant1.id}-row" do
        expect(page).to have_button("Enable")
        click_button "Enable"
      end

      expect(current_path).to eq(admin_merchants_path)
      expect(page).to have_content("#{@merchant1.name} has been re-enabled.")

      within ".user-#{@merchant1.id}-row" do
        expect(page).to have_content("#{@merchant1.name}")
        expect(page).to have_button("Disable")
      end
    end

    context 'merchant can log in after enabled by admin' do
      it 'sees a flash error when trying to log in' do
        visit login_path
        fill_in "Email", with: "#{@merchant1.email}"
        fill_in "Password", with: "#{@merchant1.password}"
        click_button "Log In"
        expect(current_path).to eq(login_path)
        expect(page).to have_content("This account has been disabled. Please contact an administrator to log in.")

        login_as(@admin)
        visit admin_merchants_path
        within ".user-#{@merchant1.id}-row" do
          click_button("Enable")
        end

        expect(page).to have_content("#{@merchant1.name} has been re-enabled")
        within ".user-#{@merchant1.id}-row" do
          expect(page).to have_button("Disable")
        end

        click_on("Log Out")

        login_as(@merchant1)
        expect(current_path).to eq(dashboard_path)
        expect(page).to have_content("#{@merchant1.name}")
      end
    end

  end

  context 'when it visits the users index' do
    it "it can disable a user" do
      visit login_path

      fill_in "email", with: @user.email
      fill_in "password", with: @user.password
      click_button("Log In")

      expect(current_path).to eq(login_path)
      expect(page).to have_content("This account has been disabled. Please contact an administrator to log in.")

      login_as(@admin)

      visit admin_users_path

      within ".user-#{@user.id}-row" do
        expect(page).to have_button("Enable")
        click_button "Enable"
      end

      expect(current_path).to eq(admin_users_path)
      expect(page).to have_content("#{@user.name} has been re-enabled.")

      within ".user-#{@user.id}-row" do
        expect(page).to have_content("#{@user.name}")
        expect(page).to have_button("Disable")
      end

      click_link("Log Out")
      click_link("Log In")

      fill_in "email", with: @user.email
      fill_in "password", with: @user.password
      click_button("Log In")

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("#{@user.name}")
    end
  end
end
