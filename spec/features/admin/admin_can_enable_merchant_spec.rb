require 'rails_helper'

RSpec.describe "As an admin", type: :feature do
  it 'I can enable merchants who were disabled, and they can log in' do
    Faker::UniqueGenerator.clear
    @admin1 = create(:user, role: 2, name: "Admin")
    @merchant1 = create(:user, role: 1, name: "Merchant", activation_status: 1)
    @merchant2, @merchant3 = create_list(:user, 2, role: 1)
    #Attempt to log in as a merchabt
    visit login_path
    fill_in "Email", with: "#{@merchant1.email}"
    fill_in "Password", with: "#{@merchant1.password}"
    click_button "Log In"
    expect(current_path).to eq(login_path)
    expect(page).to have_content("This account has been disabled. Please contact an administrator to log in.")

    #Log in as admin and re-activate the merchant
    login_as(@admin1)
    visit admin_merchants_path
    save_and_open_page
    within ".user-#{@merchant1.id}-row" do
      click_button("Enable")
    end
    expect(page).to have_content("#{@merchant1.name} has been re-enabled")
    within ".user-#{@merchant1.id}-row" do
      expect(page).to have_button("Disable")
    end
    click_on("Log Out")

    #Merchant successfully logs in again
    login_as(@merchant1)
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("#{@merchant1.name}")
  end
end
