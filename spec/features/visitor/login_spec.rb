require 'rails_helper'

RSpec.describe 'when authenticating visitors' do
  it 'can log in as a merchant' do
    user = User.create(name: "funbucket13", email: "funbucket13@gmail.com", password: "test", role: 1)

    visit items_path

    click_on "I already have an account"

    expect(current_path).to eq(login_path)
    fill_in "email", with: user.email
    fill_in "password", with: user.password

    click_button "Log In"

    expect(current_path).to eq(dashboard_path)

    expect(page).to have_content("You have been logged in as a #{user.role}")
    expect(page).to have_link("Log Out")
  end

  it 'can log in as an admin' do
    user = User.create(name: "funbucket13", email: "funbucket13@gmail.com", password: "test", role: 2)

    visit items_path

    click_on "I already have an account"

    expect(current_path).to eq(login_path)
    fill_in "email", with: user.email
    fill_in "password", with: user.password

    click_button "Log In"

    expect(current_path).to eq(items_path)

    expect(page).to have_content("You have been logged in as an #{user.role}")
    expect(page).to have_link("Log Out")
  end


  it 'can log in as a user' do
    user = User.create(name: "funbucket13", email: "funbucket13@gmail.com", password: "test")

    visit items_path

    click_on "I already have an account"

    expect(current_path).to eq(login_path)
    fill_in "email", with: user.email
    fill_in "password", with: user.password

    click_button "Log In"

    expect(current_path).to eq(profile_path)

    expect(page).to have_content("Welcome, #{user.name}!")
    expect(page).to have_content("You have been logged in as a #{user.role}")
    expect(page).to have_link("Log Out")
  end

  it 'errors and refreshes if log in attempt with no account' do
    email = "funbucket13@gmail.com"
    password = "test"

    visit items_path

    click_on "I already have an account"

    expect(current_path).to eq(login_path)
    fill_in "email", with: email
    fill_in "password", with: password

    click_button "Log In"

    expect(current_path).to eq(login_path)

    expect(page).to have_selector("input[type=submit][value='Log In']")

    ##add expect error messages
  end
end
