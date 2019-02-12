require 'rails_helper'

RSpec.describe "As an admin", type: :feature do
  it 'user sees appropriate nav bar links' do
    user = User.create(name: "tester", email: "test@email.com", password: "test", role: 2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit dashboard_path

    within ".general-nav" do
      expect(page).to have_link("Home")
      expect(page).to have_link("Admin Dashboard")
      expect(page).to have_link("Users")
      expect(page).to have_link("Browse Dishes")
      expect(page).to have_link("Restaurants")
    end

    within ".auth-nav" do
      expect(page).to have_link("Log Out")
      expect(page).to_not have_link("Log In")
      expect(page).to_not have_link("Register")
    end

    within ".cart-nav" do
      expect(page).to_not have_link("Cart")
    end

    expect(page).to have_content("Logged in as #{user.name}")
  end
end
