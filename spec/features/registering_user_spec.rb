require 'rails_helper'

RSpec.describe "Registering user", type: :feature do
  it 'shows a form' do
    name = "funbucket13"
    email = "funbucket13@gmail.com"
    visit '/register'

    click_on "Sign Up to Be a User"

    expect(current_path).to eq(new_user_path)

    fill_in :user_name, with: name
    fill_in :user_email, with: email
    fill_in :user_password, with: "test"

    click_on "Create User"

    expect(page).to have_content("Welcome, #{name}!")
  end
end
