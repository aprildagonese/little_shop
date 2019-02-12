require 'rails_helper'

RSpec.describe 'as a registered user', type: :feature do

  before :each do
    @user = create(:user)
  end

  it 'logs in and sees a profile with account info' do

    visit login_path

    fill_in "email", with: @user.email
    fill_in "password", with: @user.password

    binding.pry
    click_button "Log In"
    save_and_open_page


    expect(page).to have_content("Name: #{@user.name}")
    expect(page).to have_content("Address: #{@user.address}")
    expect(page).to have_content("City: #{@user.city}")
    expect(page).to have_content("State: #{@user.state}")
    expect(page).to have_content("Zip Code: #{@user.zip_code}")
    expect(page).to have_content("Email: #{@user.email}")
  end

end
