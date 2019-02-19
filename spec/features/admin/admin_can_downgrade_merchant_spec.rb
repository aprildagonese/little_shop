require 'rails_helper'

RSpec.describe "As an admin", type: :feature do
  before :each do
    Faker::UniqueGenerator.clear

    @admin = create(:user, role: 2)
    login_as(@admin)
    @merchant = create(:user, name: "Merchant Man", role: 1)
    @item_1 = create(:item)
    @item_2 = create(:item)
    @merchant.items << @item_1
    @merchant.items << @item_2
  end

  context "when it visits a merchant's dashboard" do
    it 'sees a button to downgrade a merchant to a user that redirects to the admin user show page' do
      visit admin_merchant_path(@merchant)

      expect(page).to have_button("Downgrade Merchant")
    end

    context 'clicks the button to downgrade merchant' do
      it 'redirects to an admin user show path and merchant role is now a user' do
        visit admin_merchant_path(@merchant)

        click_button "Downgrade Merchant"

        expect(current_path).to eq(admin_user_path(@merchant))

        expect(page).to have_content("Merchant has been downgraded to a user")
        expect(page).to_not have_button("Downgrade")
      end

      it 'no longer shows the newly downgraded merchant on the merchant index and they appear on the user index page instead' do
        visit admin_merchants_path
        expect(page).to have_content(@merchant.name)

        visit admin_users_path
        expect(page).to_not have_content(@merchant.name)

        visit admin_merchant_path(@merchant)
        click_button "Downgrade Merchant"

        visit admin_merchants_path
        
        expect(page).to_not have_content(@merchant.name)

        visit admin_users_path
        expect(page).to have_content(@merchant.name)
      end

      it 'disables all items that were for sale by that merchant' do
        visit items_path
        expect(page).to have_content(@item_1.title)
        expect(page).to have_content(@item_2.title)

        visit admin_merchant_path(@merchant)
        click_button "Downgrade Merchant"

        visit items_path
        expect(page).to_not have_content(@item_1.title)
        expect(page).to_not have_content(@item_2.title)
      end
    end
  end
end
