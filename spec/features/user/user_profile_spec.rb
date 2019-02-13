require 'rails_helper'

RSpec.describe 'as a registered user', type: :feature do

  before :each do
    @user = create(:user)
  end

  it 'logs in and sees a profile with account info' do

    visit login_path

    fill_in "email", with: @user.email
    fill_in "password", with: @user.password

    click_button "Log In"

    within ".profile" do
      expect(page).to have_content("Name: #{@user.name}")
      expect(page).to have_content("Address: #{@user.street_address}")
      expect(page).to have_content("City: #{@user.city}")
      expect(page).to have_content("State: #{@user.state}")
      expect(page).to have_content("Zip Code: #{@user.zip_code}")
      expect(page).to have_content("Email: #{@user.email}")
    end

    expect(page).to have_button("View Orders")
    expect(page).to have_button("Edit Profile")

  end

  it "clicking 'view orders' brings user to their order index page" do

    visit login_path

    fill_in "email", with: @user.email
    fill_in "password", with: @user.password

    click_button "Log In"

    click_button 'View Orders'

    expect(current_path).to eq(profile_orders_path)
  end

  it "clicking 'edit profile' brings user to their edit profile form" do

    visit login_path

    fill_in "email", with: @user.email
    fill_in "password", with: @user.password

    click_button "Log In"

    click_button 'Edit Profile'

    expect(current_path).to eq(profile_edit_path)
  end

end
