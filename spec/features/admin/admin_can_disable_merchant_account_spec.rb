require 'rails_helper'

RSpec.describe "As an admin", type: :feature do
  before :each do
    Faker::UniqueGenerator.clear

    @admin = create(:user, role: 2)
    login_as(@admin)
    @merchant = create(:merchant)
  end

  context 'when it visits the merchant index page and click the disable button for a merchant' do
    it "it redirects to the admin merchant index, shows a flash message saying they've been disabled, and shows the merchant as disabled" do
      visit merchants_path

      click_button "Disable"

      expect(current_path).to eq(admin_merchants_path)

    end
  end
end
