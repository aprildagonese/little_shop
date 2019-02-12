require 'rails_helper'

RSpec.describe 'when authenticating visitors' do
  context 'a user trying to register' do
    it 'can register by providing all required info' do
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

    it "can't register with an existing email address" do
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

      expect(page).to have_content("Your account could not be created with those credentials. Please try again or log in with an existing account.")
      expect(User.last).to eq(fae)
    end

    it 'after registering with duplicate email, it will render form with all fields filled in except email and passwords' do
      april = User.create(name: 'April', email: 'april@email.com', password: 'test')

      visit register_path

      fill_in :user_name, with: "Scott"
      fill_in :user_email, with: "april@email.com"
      fill_in :user_street_address, with: "1 road street"
      fill_in :user_city, with: "Denver"
      fill_in :user_state, with: "CO"
      fill_in :user_zip_code, with: 80203
      fill_in :user_password, with: "test"
      fill_in :user_password_confirmation, with: "test"

      click_on "Create User"

      expect(page).to have_field(:user_name, with: 'Scott')
      expect(page).to have_field(:user_email, with: '')
      expect(page).to have_field(:user_street_address, with: '1 road street')
      expect(page).to have_field(:user_city, with: 'Denver')
      expect(page).to have_field(:user_state, with: 'CO')
      expect(page).to have_field(:user_zip_code, with: 80203)
      expect(page).to have_field(:user_password, with: '')
      expect(page).to have_field(:user_password_confirmation, with: '')
    end

    it "can't register without providing email address" do
      visit items_path
      click_on "Sign Up to Be a User"

      expect(current_path).to eq(register_path)

      fill_in :user_name, with: "April Dagonese"
      fill_in :user_street_address, with: "1111 Street Dr."
      fill_in :user_city, with: "Denver"
      fill_in :user_state, with: "CO"
      fill_in :user_zip_code, with: 80202
      fill_in :user_password, with: "test"
      fill_in :user_password_confirmation, with: "test"

      click_on "Create User"

      expect(page).to have_field(:user_name)
      expect(page).to have_field(:user_email)
      expect(page).to have_field(:user_street_address)
      expect(page).to have_field(:user_city)
      expect(page).to have_field(:user_state)
      expect(page).to have_field(:user_zip_code)
      expect(page).to have_field(:user_password)
      expect(page).to have_field(:user_password_confirmation)
    end
  end
end
