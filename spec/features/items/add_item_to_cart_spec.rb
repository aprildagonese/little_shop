require 'rails_helper'

RSpec.describe 'From an items show page' do
  before :each do
    @item = create(:item)
  end
  context 'as a visitor' do
    it 'can add an item to their cart' do
      visit item_path(@item.slug)

      click_button "Add Item To Cart"

      expect(current_path).to eq(items_path)
      expect(page).to have_content("1 #{@item.title} has been added to your cart.")
      expect(page).to have_content("Cart (1)")
    end
  end

  context 'as a registered user' do
    it 'can add an item to their cart' do
      user = create(:user, password: 'test', email: 'email@email.com', role: 0)
      visit login_path
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button "Log In"

      visit item_path(@item.slug)

      click_button "Add Item To Cart"

      expect(current_path).to eq(items_path)
      expect(page).to have_content("1 #{@item.title} has been added to your cart.")
      expect(page).to have_content("Cart (1)")
    end
  end
end
