# require 'rails_helper'
#
# RSpec.describe "As an admin", type: :feature do
#   context 'when it visits the merchant index page and click the disable button for a merchant' do
#     before :each do
#       Faker::UniqueGenerator.clear
#
#       @admin = create(:user, role: 2)
#       login_as(@admin)
#       @merchant = create(:merchant)
#     end
#     it "it redirects to the admin merchant index, shows a flash message saying they've been disabled, and shows the merchant as disabled" do
#       visit merchants_path
#
#       click_button "Disable"
#
#       expect(current_path).to eq(admin_merchants_path)
#       expect(page).to have_content("#{@merchant.name} has been disabled.")
#     end
#   end
#   context 'merchant can no longer log in after disabled by admin' do
#     before :each do
#       Faker::UniqueGenerator.clear
#       @admin1 = create(:user, role: 2, name: "Admin")
#       @merchant1 = create(:user, role: 1, name: "Merchant")
#       @merchant2, @merchant3 = create_list(:user, 2, role: 1)
#     end
#     it 'sees a flash error when trying to log in' do
#       login_as(@merchant1)
#       expect(current_path).to eq(dashboard_path)
#       expect(page).to have_content("#{@merchant1.name}")
#       click_on("Log Out")
#
#       login_as(@admin1)
#       visit admin_merchants_path
#       within ".user-#{@merchant1.id}-row" do
#         click_button("Disable")
#       end
#       expect(page).to have_content("#{@merchant1.name} has been disabled")
#       within ".user-#{@merchant1.id}-row" do
#         expect(page).to have_button("Enable")
#       end
#       click_on("Log Out")
#
#       visit login_path
#       fill_in "Email", with: "#{@merchant1.email}"
#       fill_in "Password", with: "#{@merchant1.password}"
#       click_button "Log In"
#       expect(current_path).to eq(login_path)
#       expect(page).to have_content("This account has been disabled. Please contact an administrator to log in.")
#     end
#   end
# end
