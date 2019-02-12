require 'rails_helper'

RSpec.describe 'as a visitor' do

  it 'can register new user' do
    name = "funbucket13"
    email = "funbucket13@gmail.com"
    address = "1234 St."
    city = "Denver"
    state = "CO"
    zip_code = 80304

    visit items_path

    click_on "Sign Up to Be a User"

    expect(current_path).to eq(register_path)

    fill_in :user_name, with: name
    fill_in :user_email, with: email
    fill_in :user_street_address, with: address
    fill_in :user_city, with: city
    fill_in :user_state, with: state
    fill_in :user_zip_code, with: zip_code
    fill_in :user_password, with: "test"
    fill_in :user_password_confirmation, with: "test"

    click_on "Create User"

    #TODO flash message indicating you have been registered
    expect(page).to have_content("Welcome, #{name}!")
  end



  it 'errors and refreshes if credentials bad' do
    user = User.create(name: "funbucket13", email: "funbucket13@gmail.com", password: "test")

    name = "funbucket13"
    email = "funbucket13@gmail.com"

    visit items_path

    click_on "Sign Up to Be a User"

    expect(current_path).to eq(register_path)

    fill_in :user_name, with: name
    fill_in :user_email, with: email
    fill_in :user_password, with: "test"

    click_on "Create User"

    expect(page).to have_selector("input[type=submit][value='Create User']")

    ##Add expect error flash messages
  end

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
    expect(page).to have_content("Failed to log you in, please check name and email.")
  end
end
