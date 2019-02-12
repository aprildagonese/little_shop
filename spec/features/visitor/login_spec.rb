require 'rails_helper'

RSpec.describe 'as a visitor' do

  it 'can register new user' do
    visit items_path
    click_on "Sign Up to Be a User"

    expect(current_path).to eq(register_path)

    fill_in :user_name, with: "April Dagonese"
    fill_in :user_email, with: "april@email.com"
    fill_in :user_street_address, with: "1111 Street Dr."
    fill_in :user_city, with: "Denver"
    fill_in :user_state, with: "CO"
    fill_in :user_zip_code, with: 80202
    fill_in :user_password, with: "test"
    fill_in :user_password_confirmation, with: "test"

    click_on "Create User"
    user = User.last

    expect(current_path).to eq(profile_path(user))
    expect(page).to have_content("Thank you for registering! You are now logged in.")
    expect(page).to have_content("Welcome, #{user.name}!")
  end

  it "prevents account creation for existing email address" do
    fae = User.create!(name: "Fae Dagonese",
                         email: "april@email.com",
                         street_address: "222 Street Dr.",
                         city: "LA",
                         state: "CA",
                         zip_code: 90210,
                         password: "faetest",
                         password_confirmation: "faetest")
    expect(User.count).to eq(1)
    visit items_path
    click_on "Sign Up to Be a User"

    expect(current_path).to eq(register_path)

    fill_in :user_name, with: "April Dagonese"
    fill_in :user_email, with: "april@email.com"
    fill_in :user_street_address, with: "1111 Street Dr."
    fill_in :user_city, with: "Denver"
    fill_in :user_state, with: "CO"
    fill_in :user_zip_code, with: 80202
    fill_in :user_password, with: "test"
    fill_in :user_password_confirmation, with: "test"

    click_on "Create User"

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Your account could not be created with those credentials. Please try again or log in with an existing account.")
    expect(User.last).to eq(fae)

  end

  it 'rerenders the registration form with all fields prepopulated expect email after trying to register with duplicate email' do
    fae = User.create!(name: "Fae Dagonese",
                         email: "april@email.com",
                         street_address: "222 Street Dr.",
                         city: "LA",
                         state: "CA",
                         zip_code: 90210,
                         password: "faetest",
                         password_confirmation: "faetest")
    expect(User.count).to eq(1)
    visit items_path
    click_on "Sign Up to Be a User"

    expect(current_path).to eq(register_path)

    fill_in :user_name, with: "April Dagonese"
    fill_in :user_email, with: "april@email.com"
    fill_in :user_street_address, with: "1111 Street Dr."
    fill_in :user_city, with: "Denver"
    fill_in :user_state, with: "CO"
    fill_in :user_zip_code, with: 80202
    fill_in :user_password, with: "test"
    fill_in :user_password_confirmation, with: "test"

    click_on "Create User"

    save_and_open_page

    expect(current_path).to eq(register_path)
    expect(page).to have_field(:user_name, with: 'April Dagonese')
    expect(page).to have_field(:user_street_address, with: '1111 Street Dr.')
    expect(page).to have_field(:user_city, with: 'Denver')
    expect(page).to have_field(:user_state, with: 'CO')
    expect(page).to have_field(:user_zip_code, with: '80202')
    expect(page).to have_field(:user_email, with: nil)
    expect(page).to have_field(:user_password, with: nil)
    expect(page).to have_field(:user_password_confirmation, with: nil)

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

    ##add expect error messages
  end
end
