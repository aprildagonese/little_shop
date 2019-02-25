require 'rails_helper'

RSpec.describe 'as a registered user' do

  before :each do
    @user_1 = create(:user, id: 1, email: 'email@example.com', slug: 'email-example-com')
    @user_2 = create(:user, id: 2)
  end

  it 'can\'t view form unless logged in' do

    visit profile_edit_path

    expect(current_path).to eq('/404')
  end

  it 'sees a form to edit profile info' do

    login_as(@user_1)

    visit profile_path

    click_button "Edit Profile"

    expect(page).to have_content("Name")
    expect(page).to have_content("Street address")
    expect(page).to have_content("City")
    expect(page).to have_content("State")
    expect(page).to have_content("Zip code")
    expect(page).to have_content("Email")
    expect(page).to have_content("Password")
    expect(page).to have_content("Password confirmation")

    expect(page).to have_button("Update Profile")

  end

  it 'can update info through the form' do

    login_as(@user_1)

    visit profile_edit_path

    fill_in :user_name, with: "April Dagonese"
    fill_in :user_email, with: "april@email.com"
    fill_in :user_street_address, with: "1111 Street Dr."
    fill_in :user_city, with: "Denver"
    fill_in :user_state, with: "CO"
    fill_in :user_zip_code, with: 80202
    fill_in :user_password, with: "testing"
    fill_in :user_password_confirmation, with: "testing"

    expect(@user_1.id).to eq(1)

    click_button("Update Profile")

    updated_user = User.find(1)
    expect(updated_user.id).to eq(1)

    expect(current_path).to eq(profile_path)

    expect(updated_user.name).to eq("April Dagonese")
    expect(updated_user.street_address).to eq("1111 Street Dr.")
    expect(updated_user.city).to eq("Denver")
    expect(updated_user.state).to eq("CO")
    expect(updated_user.zip_code).to eq(80202)
    expect(updated_user.email).to eq("april@email.com")

    within ".profile" do
      expect(page).to have_content("Name: #{updated_user.name}")
      expect(page).to have_content("Address: #{updated_user.street_address}")
      expect(page).to have_content("City: #{updated_user.city}")
      expect(page).to have_content("State: #{updated_user.state}")
      expect(page).to have_content("Zip Code: #{updated_user.zip_code}")
      expect(page).to have_content("Email: #{updated_user.email}")
    end

  end

  it 'gets redirected if attempting to update to an email that\'s already take by another user' do

    login_as(@user_1)

    visit profile_edit_path

    fill_in :user_name, with: "April Dagonese"
    fill_in :user_email, with: @user_2.email
    fill_in :user_street_address, with: "1111 Street Dr."
    fill_in :user_city, with: "Denver"
    fill_in :user_state, with: "CO"
    fill_in :user_zip_code, with: 80202
    fill_in :user_password, with: "testing"
    fill_in :user_password_confirmation, with: "testing"

    click_button "Update Profile"

    expect(current_path).to eq(profile_edit_path)

    expect(page).to have_content("That email has already been taken")

    expect(page).to have_content("Name")
    expect(page).to have_content("Street address")
    expect(page).to have_content("City")
    expect(page).to have_content("State")
    expect(page).to have_content("Zip code")
    expect(page).to have_content("Email")
    expect(page).to have_content("Password")
    expect(page).to have_content("Password confirmation")

    expect(page).to have_button("Update Profile")

  end

  it 'updates slug only when email updates' do
    login_as(@user_1)

    visit profile_path

    click_button "Edit Profile"

    fill_in :user_name, with: "April Dagonese"

    click_button "Update Profile"

    expect(User.first.slug).to eq('email-example-com')

    click_button "Edit Profile"

    fill_in :user_email, with: "new_email@email.com"

    click_button "Update Profile"

    expect(User.first.slug).to eq('new-email-email-com')

  end

end
