require 'rails_helper'

RSpec.describe "As an admin", type: :feature do
  it 'user sees appropriate nav bar links' do
    user = User.create(name: "tester", email: "test@email.com", password: "test", role: 2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit admin_dashboard_path

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

  it 'user can visit Home' do
    user = User.create(name: "tester", email: "test@email.com", password: "test", role: 2)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit profile_path

    click_link "Home"

    expect(current_path).to eq(welcome_path)
  end

  it 'user can visit dashboard' do
    user = User.create(name: "tester", email: "test@email.com", password: "test", role: 2)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit profile_path

    click_link "Admin Dashboard"

    expect(current_path).to eq(admin_dashboard_path)
    expect(page).to have_content("All Items")
  end

  it 'user can visit users list' do
    user = User.create(name: "tester", email: "test@email.com", password: "test", role: 2)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit profile_path

    click_link "Users"

    expect(current_path).to eq(admin_users_path)
    expect(page).to have_content("All Users")
  end

  it 'user can see dishes' do
    user = User.create(name: "tester", email: "test@email.com", password: "test", role: 2)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit profile_path

    click_link "Browse Dishes"

    expect(current_path).to eq(items_path)
    expect(page).to have_content("All Items")

  end

  it 'user can see restaraunts' do
    user = User.create(name: "tester", email: "test@email.com", password: "test", role: 2)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit profile_path

    click_link "Restaurants"

    expect(current_path).to eq(merchants_path)
    expect(page).to have_content("All Restaurants")
  end
end
