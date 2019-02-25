require 'rails_helper'

RSpec.describe "As an admin", type: :feature do
  before :each do
    Faker::UniqueGenerator.clear

    @admin = create(:user, role: 2)
    login_as(@admin)

    @user = create(:user, id: 100, email: 'user@email.com', slug: 'user-email-com')
    @user2 = create(:user, id: 99, email: "taken_email")
  end

  context 'when it visits user profile page' do
    it "sees a link to edit the user's profile that takes it to the edit profile form" do
      visit admin_user_path(@user.slug)

      within '.profile' do
        expect(page).to have_content("Name: #{@user.name}")
      end

      within '.user-profile-buttons' do
        expect(page).to have_button("Edit Profile")
      end

      click_button "Edit Profile"

      expect(current_path).to eq(edit_admin_user_path(@user.slug))
      expect(page).to have_content("Edit Profile")
    end
  end

  context 'on the edit profile page' do
    it "can update a user's info through the form" do

      visit edit_admin_user_path(@user.slug)

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

      expect(current_path).to eq(admin_user_path(updated_user.slug))

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

    it "can't update a user's info with a taken email" do

      visit edit_admin_user_path(@user.slug)

      fill_in :user_name, with: "April Dagonese"
      fill_in :user_email, with: "taken_email"
      fill_in :user_street_address, with: "1111 Street Dr."
      fill_in :user_city, with: "Denver"
      fill_in :user_state, with: "CO"
      fill_in :user_zip_code, with: 80202
      fill_in :user_password, with: "testing"
      fill_in :user_password_confirmation, with: "testing"

      click_button("Update Profile")

      expect(current_path).to eq(edit_admin_user_path(@user.slug))

      expect(page).to have_content("That email has already been taken.")

      not_updated_user = User.find(100)

      expect(not_updated_user.name).to_not eq("April Dagonese")
      expect(not_updated_user.email).to_not eq("taken_email")
    end

    it 'only updates user\'s slug when changing their email' do

      visit edit_admin_user_path(@user.slug)

      fill_in :user_name, with: "User Name"

      click_button "Update Profile"

      expect(@user.slug).to eq('user-email-com')

      click_button "Edit Profile"

      fill_in :user_email, with: 'new_user@email.com'

      click_button "Update Profile"

      updated_user = User.find(100)
      expect(updated_user.id).to eq(100)

      expect(updated_user.slug).to eq('new-user-email-com')
      expect(current_path).to eq(admin_user_path(updated_user.slug))
    end

  end
end
