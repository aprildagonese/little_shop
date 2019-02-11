require 'rails_helper'

RSpec.describe "items", type: :feature do
  context 'as an admin user' do
    it 'allows admin to see all items' do
      user = User.create(name: "tester", email: "test@email.com", password: "test", role: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit admin_items_path

      expect(page).to have_content("Admin Items")
    end
  end

  context 'as a regular user' do
    it 'should not see all items' do
      visit admin_items_path
      expect(page).to_not have_content("Admin Items")
    end
  end
end
