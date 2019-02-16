require 'rails_helper'

RSpec.describe "As an admin", type: :feature do

  before :each do
    Faker::UniqueGenerator.clear

    @admin = create(:user, role: 2)
    login_as(@admin)
    @merchant = create(:user, role: 1)
    @admin_2 = create(:user, role: 2)
    @user_1 = create(:user, role: 0)
    @user_2 = create(:user, role: 0)
    @user_3 = create(:user, role: 0)
    @user_4 = create(:user, role: 0, activation_status: 1)
    @user_5 = create(:user, role: 0, activation_status: 1)
    @user_6 = create(:user, role: 0, activation_status: 1)
  end

  context "when it clicks on the User's link in the nav" do
    it 'shows all users in the system who are not merchants nor admins' do
      visit welcome_path

      click_link "Users"

      expect(current_path).to eq(admin_users)

      expect(page).to_have("All Users")



    end

    it "all user's names are links to their show pages" do
    end

    it "next to each user's name is the date they registered" do
    end

    it "next to each user's name is a button that says 'enable' or 'disable' based on their current status" do
    end
  end
end
