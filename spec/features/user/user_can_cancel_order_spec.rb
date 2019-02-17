require 'rails_helper'

RSpec.describe "As a registered user", type: :feature do
  before :each do
    @user = User.create(name: "tester", email: "test@email.com", password: "test")
    login_as(@user)

    binding.pry
  end


end
