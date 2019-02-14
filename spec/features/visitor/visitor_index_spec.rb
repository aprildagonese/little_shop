require 'rails_helper'

RSpec.describe "visitor index page", type: :feature do

  before :each do
    Faker::UniqueGenerator.clear
    @visitor = create(:user)
    @merch1, @merch2, @merch3 = create_list(:user, 3, role: 1)
    @i1, @i2, @i3, @i4, @i5, @i6 = create_list(:item, 6)
    @i1.update(user: @merch1)
    @i2.update(user: @merch2)
    @i3.update(user: @merch2)
    @i4.update(user: @merch3)
    @i5.update(user: @merch3)
    @i6.update(user: @merch3)
  end

  describe 'as a visitor' do
    context 'after entering site' do

      it 'can see list of items' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@visitor)
        visit items_path

        within ".id-#{@i1.id}-row" do
          expect(page).to have_content("#{@i1.image_url}")
          expect(page).to have_content("#{@i1.title}")
          expect(page).to have_content("Current Price: $#{@i1.price}")
          expect(page).to have_content("Qty: #{@i1.quantity}")
          expect(page).to have_content("Sold By: #{@i1.user.name}")
        end
      end

      it 'can see link to register new user' do
        visit items_path

        expect(page).to have_link("Register")

        click_on "Register"

        expect(current_path).to eq(register_path)
      end

      it 'can see link to sign in' do
        visit items_path

        expect(page).to have_link("Log In")

        click_on "Log In"

        expect(current_path).to eq(login_path)
      end

      it 'can register new user' do
        name = "funbucket13"
        email = "funbucket13@gmail.com"
        address = "1234 St."
        city = "Denver"
        state = "CO"
        zip_code = 80304

        visit items_path

        click_on "Register"

        expect(current_path).to eq(register_path)

        fill_in :user_name, with: name
        fill_in :user_email, with: email
        fill_in :user_street_address, with: address
        fill_in :user_city, with: city
        fill_in :user_state, with: state
        fill_in :user_zip_code, with: zip_code
        fill_in :user_password, with: "test"
        fill_in :user_password_confirmation, with: "test"

        click_on "Create User"

        expect(page).to have_content("Welcome, #{name}!")
      end



      it 'errors and refreshes if credentials bad' do
        user = User.create(name: "funbucket13", email: "funbucket13@gmail.com", password: "test")

        name = "funbucket13"
        email = "funbucket13@gmail.com"

        visit items_path

        click_on "Register"

        expect(current_path).to eq(register_path)

        fill_in :user_name, with: name
        fill_in :user_email, with: email
        fill_in :user_password, with: "test"

        click_on "Create User"

        expect(page).to have_selector("input[type=submit][value='Create User']")

        ##Add expect error flash messages
      end



      it 'can log in' do
        user = User.create(name: "funbucket13", email: "funbucket13@gmail.com", password: "test")

        visit items_path

        click_on "Log In"

        expect(current_path).to eq(login_path)
        fill_in "email", with: user.email
        fill_in "password", with: user.password

        click_button "Log In"

        expect(current_path).to eq(profile_path)

        expect(page).to have_content("Welcome, #{user.name}!")
        expect(page).to have_link("Log Out")
      end



      it 'errors and refreshes if log in attempt with no account' do
        email = "funbucket13@gmail.com"
        password = "test"

        visit items_path

        click_on "Log In"

        expect(current_path).to eq(login_path)
        fill_in "email", with: email
        fill_in "password", with: password

        click_button "Log In"

        expect(current_path).to eq(login_path)

        expect(page).to have_selector("input[type=submit][value='Log In']")

        ##add expect error messages
      end
    end
  end
end
