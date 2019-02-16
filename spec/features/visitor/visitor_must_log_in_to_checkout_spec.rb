require 'rails_helper'

RSpec.describe "visitor cart page", type: :feature do

  before :each do
    Faker::UniqueGenerator.clear
    @item_1 = create(:item)
    @item_2 = create(:item)
    @item_3 = create(:item)
  end


  context 'as a visitor with items in the cart' do
    it 'it requires a visitor register or log in before checking out' do
      visit item_path(@item_1)
      click_button "Add Item To Cart"
      visit item_path(@item_2)
      click_button "Add Item To Cart"
      visit item_path(@item_3)
      click_button "Add Item To Cart"

      visit cart_path

      expect(page).to have_content("You must register or log in before checking out.")
      expect(page).to_not have_button("Check Out")

      within '#checkout' do
        click_link "register"
      end

      expect(current_path).to eq(register_path)

      visit cart_path

      within '#checkout' do
        click_link "log in"
      end

      expect(current_path).to eq(login_path)
    end
  end
end
