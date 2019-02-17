require 'rails_helper'

RSpec.describe "Path Authorizations", type: :feature do
  before :each do
    @merchant = create(:user, role: 1)
  end
  context 'as a visitor' do
    it 'sends a 404 if it does not have permission to visit a path' do
      visit admin_merchant_path(@merchant)

      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end

  context 'as a registered user' do
    it 'sends a 404 if I do not have permission to visit a path' do
      user = create(:user, role: 0)
      login_as(user)

      visit admin_merchant_path(@merchant)
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end

  context 'as a merchant' do
    it 'sends a 404 if I do not have permission to visit a path' do
      merchant_2 = create(:user, role: 1)
      login_as(merchant_2)

      visit admin_merchant_path(@merchant)
      expect(page).to have_content("The page you were looking for doesn't exist (404)")
    end
  end
end
