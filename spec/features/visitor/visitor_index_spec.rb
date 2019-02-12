require 'rails_helper'

RSpec.describe "visitor index page", type: :feature do

  # before :each do
  #   @item_1 = Item.create(name: )
  # end
  #
  describe 'as a visitor' do
    context 'after entering site' do
      it 'can see list of items' do
      end

      it 'can see link to register new user' do
        visit items_path

        expect(page).to have_link("Sign Up to Be a User")

        click_on "Sign Up to Be a User"

        expect(current_path).to eq(register_path)
      end

      it 'can see link to sign in' do
        visit items_path

        expect(page).to have_link("I already have an account")

        click_on "I already have an account"

        expect(current_path).to eq(login_path)
      end

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

      it 'can log in' do
        user = User.create(name: "funbucket13", email: "funbucket13@gmail.com", password: "test")

        visit items_path

        click_on "I already have an account"

        expect(current_path).to eq(login_path)
        fill_in "email", with: user.email
        fill_in "password", with: user.password

        click_on "Log In"

        expect(current_path).to eq(profile_path)

        expect(page).to have_content("Welcome, #{user.name}!")
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

        click_on "Log In"

        expect(current_path).to eq(login_path)

        expect(page).to have_selector("input[type=submit][value='Log In']")

        ##add expect error messages
      end

      it 'can log out' do
        user = User.create(name: "funbucket13", email: "funbucket13@gmail.com", password: "test")

        visit items_path

        click_on "I already have an account"

        fill_in "email", with: user.email
        fill_in "password", with: user.password

        click_on "Log In"

        expect(current_path).to eq(profile_path)

        expect(page).to have_content("Welcome, #{user.name}!")
        expect(page).to have_link("Log Out")

        click_on "Log Out"

        expect(current_path).to eq(welcome_path)

        ##Add expect flash message

      end
    end
  end
  #
  # describe 'As a visitor' do
  #   xit 'displays all items' do
  #
  # 	visit '/items'
  #
  # 	expect..
  #
  #   end
end
