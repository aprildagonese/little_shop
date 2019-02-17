require 'rails_helper'

RSpec.describe "As an admin", type: :feature do

  before :each do
    Faker::UniqueGenerator.clear

<<<<<<< HEAD
    @admin = create(:user, role: 2)
    login_as(@admin)
    @merchant = create(:user, role: 1)
    @admin_2 = create(:user, role: 2)
=======
    @admin = create(:user, name: "IAmAdmin", role: 2)
    login_as(@admin)
    @merchant = create(:user, name: "IAmMerchant", role: 1)
    @admin_2 = create(:user, name: "IAmAdmin2", role: 2)
>>>>>>> 9a80fd69e4d6dc61adf3546bb456726e14907273
    @user_1 = create(:user, role: 0)
    @user_2 = create(:user, role: 0)
    @user_3 = create(:user, role: 0)
    @user_4 = create(:user, role: 0, activation_status: 1)
    @user_5 = create(:user, role: 0, activation_status: 1)
    @user_6 = create(:user, role: 0, activation_status: 1)
  end

<<<<<<< HEAD
  context "when it clicks on the User's link in the nav" do
=======
  context "when it clicks on the Users link in the nav" do
>>>>>>> 9a80fd69e4d6dc61adf3546bb456726e14907273
    it 'shows all users in the system who are not merchants nor admins' do
      visit welcome_path

      click_link "Users"

<<<<<<< HEAD
      expect(current_path).to eq(admin_users)

      expect(page).to_have("All Users")


=======
      expect(current_path).to eq(admin_users_path)

      expect(page).to have_content("All Users")

      within ".user-#{@user_1.id}-row" do
        expect(page).to have_content(@user_1.name)
        expect(page).to have_content(@user_1.city)
        expect(page).to have_content(@user_1.state)
      end
      within ".user-#{@user_2.id}-row" do
        expect(page).to have_content(@user_2.name)
        expect(page).to have_content(@user_2.city)
        expect(page).to have_content(@user_2.state)
      end
      within ".user-#{@user_3.id}-row" do
        expect(page).to have_content(@user_3.name)
        expect(page).to have_content(@user_3.city)
        expect(page).to have_content(@user_3.state)
      end
      within ".user-#{@user_4.id}-row" do
        expect(page).to have_content(@user_4.name)
        expect(page).to have_content(@user_4.city)
        expect(page).to have_content(@user_4.state)
      end
      within ".user-#{@user_5.id}-row" do
        expect(page).to have_content(@user_5.name)
        expect(page).to have_content(@user_5.city)
        expect(page).to have_content(@user_5.state)
      end
      within ".user-#{@user_6.id}-row" do
        expect(page).to have_content(@user_6.name)
        expect(page).to have_content(@user_6.city)
        expect(page).to have_content(@user_6.state)
      end

      expect(page).to_not have_content(@admin_2.name)
      expect(page).to_not have_content(@merchant.name)
>>>>>>> 9a80fd69e4d6dc61adf3546bb456726e14907273

    end

    it "all user's names are links to their show pages" do
<<<<<<< HEAD
    end

    it "next to each user's name is the date they registered" do
    end

    it "next to each user's name is a button that says 'enable' or 'disable' based on their current status" do
=======
      visit admin_users_path

      click_link @user_1.name

      expect(current_path).to eq(admin_user_path(@user_1))
    end

    it "next to each user's name is the date they registered and a button to enable or disable based on current activation status" do
      visit admin_users_path
      
      within ".user-#{@user_1.id}-row" do
        expect(page).to have_content(@user_1.created_at.to_date.to_s)
        expect(page).to have_button("Disable")
      end
      within ".user-#{@user_2.id}-row" do
        expect(page).to have_content(@user_2.created_at.to_date.to_s)
        expect(page).to have_button("Disable")
      end
      within ".user-#{@user_3.id}-row" do
        expect(page).to have_content(@user_3.created_at.to_date.to_s)
        expect(page).to have_button("Disable")
      end
      within ".user-#{@user_4.id}-row" do
        expect(page).to have_content(@user_4.created_at.to_date.to_s)
        expect(page).to have_button("Enable")
      end
      within ".user-#{@user_5.id}-row" do
        expect(page).to have_content(@user_5.created_at.to_date.to_s)
        expect(page).to have_button("Enable")
      end
      within ".user-#{@user_6.id}-row" do
        expect(page).to have_content(@user_6.created_at.to_date.to_s)
        expect(page).to have_button("Enable")
      end
>>>>>>> 9a80fd69e4d6dc61adf3546bb456726e14907273
    end
  end
end
