require 'rails_helper'

RSpec.describe 'as a registered user' do

  before :each do
    @user = create(:user)
  end

  it 'can\'t view form unless logged in' do
  end

  it 'sees a form to edit profile info' do
    login_as(@user)
    visit profile_edit_path
    save_and_open_page

  end

end
