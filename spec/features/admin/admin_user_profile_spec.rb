require 'rails_helper'

RSpec.describe 'as an admin', type: :feature do

  before :each do
    @user = create(:user)
    @admin = create(:user, role: 2)

    login_as(@admin)
  end

  xit 'can see a users profile with account info' do

    visit admin_profile_path(@user)

    within ".profile" do
      expect(page).to have_content("Name: #{@user.name}")
      expect(page).to have_content("Address: #{@user.street_address}")
      expect(page).to have_content("City: #{@user.city}")
      expect(page).to have_content("State: #{@user.state}")
      expect(page).to have_content("Zip Code: #{@user.zip_code}")
      expect(page).to have_content("Email: #{@user.email}")
    end

    expect(page).to have_button("Edit Profile")
    expect(page).to have_link("User Orders")

  end

  xit "admin can see users order index page" do

    visit admin_profile_path(@user)

    click_link 'User Orders'

    expect(current_path).to eq(admin_profile_order_path(@order_1))
    expect(page).to have_content("All Orders")
    expect(page).to have_content("#{@order_1.title}")
    expect(page).to have_content("#{@order_2.title}")
  end

  xit "admin can see user order show page" do

    visit admin_profile_order_path(@order_1)

    click_link 'Order 1'

    expect(current_path).to eq(admin_profile_order_path(@order_1))

    expect(page).to have_content("#{@order_1.title}")
  end

  xit "clicking 'edit profile' brings user to their edit profile form" do

    visit login_path

    fill_in "email", with: @user.email
    fill_in "password", with: @user.password

    click_button "Log In"

    click_button 'Edit Profile'

    expect(current_path).to eq(profile_edit_path)
  end

end
