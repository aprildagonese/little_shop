require 'rails_helper'

RSpec.describe "As an admin", type: :feature do
  before :each do
    @admin = create(:user, role: 2)
    login_as(@admin)

    @user = create(:user, id: 100)
  end

  context 'when it visits user profile page' do
    it "sees a link to edit the user's profile that takes it to the edit profile form" do
      visit admin_user_path(@user)

      within '.profile' do
        expect(page).to have_content("Name: #{@user.name}")
      end

      within '.user-profile-buttons' do
        expect(page).to have_button("Edit Profile")
      end

      click_button "Edit Profile"

      expect(current_path).to eq(edit_admin_user_path(@user))
      expect(page).to have_content("Edit Profile")
    end
  end

  context 'on the edit profile page' do
    it "can update a user's info through the form" do

      visit edit_admin_user_path(@user)
  
      fill_in :user_name, with: "April Dagonese"
      fill_in :user_email, with: "april23@email.com"
      fill_in :user_street_address, with: "1111 Street Dr."
      fill_in :user_city, with: "Denver"
      fill_in :user_state, with: "CO"
      fill_in :user_zip_code, with: 80202
      fill_in :user_password, with: "testing"
      fill_in :user_password_confirmation, with: "testing"

      expect(@user.id).to eq(100)
  
      click_button("Update Profile")

      updated_user = User.find(100)
      expect(updated_user.id).to eq(100)

      expect(current_path).to eq(admin_user_path(@user))

      expect(updated_user.name).to eq("April Dagonese")
      expect(updated_user.street_address).to eq("1111 Street Dr.")
      expect(updated_user.city).to eq("Denver")
      expect(updated_user.state).to eq("CO")
      expect(updated_user.zip_code).to eq(80202)
      expect(updated_user.email).to eq("april23@email.com")

      within ".profile" do
        expect(page).to have_content("Name: #{updated_user.name}")
        expect(page).to have_content("Address: #{updated_user.street_address}")
        expect(page).to have_content("City: #{updated_user.city}")
        expect(page).to have_content("State: #{updated_user.state}")
        expect(page).to have_content("Zip Code: #{updated_user.zip_code}")
        expect(page).to have_content("Email: #{updated_user.email}")
      end
  
    end
  end
end
