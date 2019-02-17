require 'rails_helper'

RSpec.describe "As an admin", type: :feature do
  before :each do
    @admin = create(:user, role: 2)
    login_as(@admin)
    @merchant = create(:user, role: 1)
  end
  context "when it visits a merchant's dashboard" do
    it 'sees a link to downgrade a merchant to a user' do
      visit admin_merchant_path(@merchant)
      save_and_open_page
    end
  end
end
