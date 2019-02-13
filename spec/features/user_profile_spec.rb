require 'rails_helper'

RSpec.describe 'as a registered user', type: :feature do

  before :each do
    @user = create(:user)
  end

  xit 'logs in and sees a profile with account info' do

    visit login_path

    fill_in "email", with: @user.email
    fill_in "password", with: @user.password

    click_button "Log In"

    expect(page).to have_content("Name: #{@user.name}")
    expect(page).to have_content("Address: #{@user.address}")
    expect(page).to have_content("City: #{@user.city}")
    expect(page).to have_content("State: #{@user.state}")
    expect(page).to have_content("Zip Code: #{@user.zip_code}")
    expect(page).to have_content("Email: #{@user.email}")
  end

end
