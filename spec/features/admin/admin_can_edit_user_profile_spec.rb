require 'rails_helper'

RSpec.describe "As an admin", type: :feature do
  before :each do
    @admin = create(:user, role: 2)
    login_as(@admin)

    @user = create(:user, id: 100)
  end

  context 'when it visits user profile page' do
    it 'sees a link to  edit the users profile' do
      visit admin_user_path(@user)

      within '.profile' do
        expect(page).to have_content("Name: #{@user.name}")
      end

      within '.user-profile-buttons' do
        expect(page).to have_button("Edit Profile")
      end


      click_button "Edit Profile"

      expect(current_path).to eq(edit_admin_user_path(@user))

    end
  end
end
