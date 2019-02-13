require 'rails_helper'

RSpec.describe "As a registered user", type: :feature do
  it 'user sees appropriate nav bar links' do
    user = User.create(name: "tester", email: "test@email.com", password: "test")

    visit login_path

    fill_in 'email', with: user.email
    fill_in 'password', with: user.password

    click_button "Log In"

    within ".general-nav" do
      expect(page).to have_link("Home")
      expect(page).to have_link("My Profile")
      expect(page).to have_link("Browse Dishes")
      expect(page).to have_link("Restaurants")
    end

    within ".auth-nav" do
      expect(page).to have_link("Log Out")
      expect(page).to_not have_link("Log In")
      expect(page).to_not have_link("Register")
    end

    within ".cart-nav" do
      expect(page).to have_link("Cart")
    end

    expect(page).to have_content("Logged in as #{user.name}")

  end
end
