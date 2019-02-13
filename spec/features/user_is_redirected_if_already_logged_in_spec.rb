require 'rails_helper'

RSpec.describe "Once already logged in", type: :feature do
  context 'as a registered user' do
    it 'will redirect to the user profile if we try to go to the login path' do
      user = create(:user, email: 'user@email.com', password:'test', role: 0)

      visit login_path

      fill_in "email", with: 'user@email.com'
      fill_in "password", with: 'test'

      click_button "Log In"

      visit login_path

      expect(current_path).to eq(profile_path)
    end
  end

  context 'as a merchant user' do
    it 'will redirect to the merchant dashboard if we try to go to the login path' do
      user = create(:user, email: 'user@email.com', password:'test', role: 1)

      visit login_path

      fill_in "email", with: user.email
      fill_in "password", with: user.password

      click_button "Log In"

      visit login_path

      expect(current_path).to eq(dashboard_path)
    end
  end

  context 'as an admin user' do
    it 'will redirect to the home page of the site if I try to go to the login path' do
      user = create(:user, email: 'user@email.com', password:'test', role: 2)

      visit login_path

      fill_in "email", with: user.email
      fill_in "password", with: user.password

      click_button "Log In"

      visit login_path

      expect(current_path).to eq(items_path)
    end
  end
end
