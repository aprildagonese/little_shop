require 'rails_helper'

RSpec.describe 'as a registered user' do

  before :each do
    @user_1 = create(:user)
    @user_2 = create(:user)
  end

  it 'can\'t view form unless logged in' do

  end

  it 'sees a form to edit profile info' do

    login_as(@user_1)

    visit profile_edit_path

    expect(page).to have_content("Name")
    expect(page).to have_content("Street address")
    expect(page).to have_content("City")
    expect(page).to have_content("State")
    expect(page).to have_content("Zip code")
    expect(page).to have_content("Email")
    expect(page).to have_content("Password")
    expect(page).to have_content("Password confirmation")

  end

end
