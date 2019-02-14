require 'rails_helper'

describe 'as a logged in user' do

  it 'can log out' do
    user = User.create(name: "funbucket13", email: "funbucket13@gmail.com", password: "test")

    visit items_path

    click_on "Log In"

    fill_in "email", with: user.email
    fill_in "password", with: user.password

    click_button "Log In"

    expect(current_path).to eq(profile_path)

    expect(page).to have_content("Welcome, #{user.name}!")
    expect(page).to have_link("Log Out")

    click_on "Log Out"

    expect(current_path).to eq(welcome_path)
    expect(page).to have_link("Log In")
    expect(page).to have_link("Register")
    expect(page).to have_content("You are logged out")

    expect(page).to_not have_link("Log Out")
  end

end
