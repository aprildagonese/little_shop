module Helpers
  module Authentication
    def login_as(user)
      visit login_path
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Log In'
    end
  end
end
