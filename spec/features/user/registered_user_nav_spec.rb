require 'rails_helper'

RSpec.describe "As a registered user", type: :feature do
  # before :each do
  #   @user = User.create(name: "tester", email: "test@email.com", password: "test")
  #   allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  #   visit profile_path
  # end

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

  it 'user can visit Home' do
    user = User.create(name: "tester", email: "test@email.com", password: "test")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit profile_path

    click_link "Home"

    expect(current_path).to eq(welcome_path)
  end

  it 'user can visit profile' do
    user = User.create(name: "tester", email: "test@email.com", password: "test")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit profile_path

    click_link "My Profile"

    expect(current_path).to eq(profile_path)
    expect(page).to have_content("Welcome, #{user.name}!")
  end

  it 'user can see dishes' do
    user = User.create(name: "tester", email: "test@email.com", password: "test")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit profile_path

    click_link "Browse Dishes"

    expect(current_path).to eq(items_path)
    expect(page).to have_content("All Items")

  end

  it 'user can see restaraunts' do
    user = User.create(name: "tester", email: "test@email.com", password: "test")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit profile_path

    click_link "Restaurants"

    expect(current_path).to eq(merchants_path)
    expect(page).to have_content("All Restaurants")
  end

  it 'user can visit their cart' do
    user = User.create(name: "tester", email: "test@email.com", password: "test")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit profile_path

    click_link "Cart"

    expect(current_path).to eq(cart_path)
    expect(page).to have_content("My Cart")
  end

end
