require 'rails_helper'

RSpec.describe 'as a visitor' do

  it 'can log in as a merchant' do
    user = create(:user, name: "funbucket13", email: "funbucket13@gmail.com", password: "test", role: 1)
  end

  it 'errors and refreshes if log in attempt with no account' do
    email = "funbucket13@gmail.com"
    password = "test"


    visit items_path

    click_on "Log In"

    expect(current_path).to eq(login_path)

    fill_in "email", with: email
    fill_in "password", with: password

    click_button "Log In"

    expect(current_path).to eq(login_path)

    expect(page).to have_selector("input[type=submit][value='Log In']")
    expect(page).to have_content("Login failed. Please check your email address and password.")
  end

  it 'errors and refreshes if log in attempt without both name and password' do
    email = "funbucket13@gmail.com"
    password = "test"

    visit login_path

    fill_in "email", with: email

    click_button "Log In"

    expect(current_path).to eq(login_path)

    expect(page).to have_selector("input[type=submit][value='Log In']")
    expect(page).to have_content("Login failed. Please check your email address and password.")

    fill_in "password", with: password

    expect(current_path).to eq(login_path)

    expect(page).to have_selector("input[type=submit][value='Log In']")
    expect(page).to have_content("Login failed. Please check your email address and password.")
  end

  it 'can log in as a merchant' do
    user = create(:user, name: "funbucket13", email: "funbucket13@gmail.com", password: "test", role: 1)

    visit login_path

    fill_in "email", with: user.email
    fill_in "password", with: user.password

    click_button "Log In"

    expect(current_path).to eq(dashboard_path)

    expect(page).to have_content("You have been logged in.")
    expect(page).to have_link("Log Out")
  end

  it 'can log in as an admin' do
    user = create(:user, name: "funbucket13", email: "funbucket13@gmail.com", password: "test", role: 2)

    visit login_path

    fill_in "email", with: user.email
    fill_in "password", with: user.password

    click_button "Log In"

    expect(current_path).to eq(welcome_path)

    expect(page).to have_content("You have been logged in.")
    expect(page).to have_link("Log Out")
  end

  it 'can log in as a user' do
    user = create(:user, name: "funbucket13", email: "funbucket13@gmail.com", password: "test")

    visit login_path

    fill_in "email", with: user.email
    fill_in "password", with: user.password

    click_button "Log In"

    expect(current_path).to eq(profile_path)

    expect(page).to have_content("You have been logged in.")
    expect(page).to have_link("Log Out")
  end

end
