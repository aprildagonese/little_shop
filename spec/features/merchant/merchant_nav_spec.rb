require 'rails_helper'

RSpec.describe "As a merchant", type: :feature do

  before :each do
    @merchant = create(:user, role: 1)
    login_as(@merchant)
  end

  it 'user sees appropriate nav bar links' do

    visit dashboard_path

    within ".general-nav" do
      expect(page).to have_link("Home")
      expect(page).to have_link("Browse Dishes")
      expect(page).to have_link("Restaurants")
    end

    within ".personal-nav" do
      expect(page).to have_link("My Dashboard")
    end

    within ".auth-nav" do
      expect(page).to have_link("Log Out")
      expect(page).to_not have_link("Log In")
      expect(page).to_not have_link("Register")
    end

    within ".cart-nav" do
      expect(page).to_not have_link("Cart")
    end

    expect(page).to have_content("Logged in as #{@merchant.name}")
  end

  it 'user can visit Home' do

    visit profile_path

    click_link "Home"

    expect(current_path).to eq(welcome_path)
  end

  it 'user can visit dashboard' do

    visit profile_path

    click_link "My Dashboard"

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Welcome, #{@merchant.name}!")
  end

  it 'user can see dishes' do

    visit profile_path

    click_link "Browse Dishes"

    expect(current_path).to eq(items_path)
    expect(page).to have_content("All Items")

  end

  it 'user can see restaraunts' do

    visit profile_path

    click_link "Restaurants"

    expect(current_path).to eq(merchants_path)
    expect(page).to have_content("All Restaurants")
  end

  it "merchant cannot see pages without permission" do


    visit profile_path
    expect(page).to have_content("The page you were looking for doesn't exist.")

    visit profile_edit_path
    expect(page).to have_content("The page you were looking for doesn't exist.")

    visit profile_orders_path
    expect(page).to have_content("The page you were looking for doesn't exist.")

    visit admin_dashboard_path
    expect(page).to have_content("The page you were looking for doesn't exist.")

    visit admin_items_path
    expect(page).to have_content("The page you were looking for doesn't exist.")

    visit admin_merchants_path
    expect(page).to have_content("The page you were looking for doesn't exist.")

    visit carts_path
    expect(page).to have_content("The page you were looking for doesn't exist.")

    visit cart_path
    expect(page).to have_content("The page you were looking for doesn't exist.")

  end

end
