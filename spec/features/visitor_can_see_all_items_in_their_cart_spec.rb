require 'rails_helper'

RSpec.describe 'Cart show page' do
  context 'as a visitor' do
    it 'shows me all items in my cart' do
      item_1 = create(:item, id:1, quantity: 3)
      item_2 = create(:item, id:2, quantity: 20)
      cart = Cart.new({
        1 => 3,
        2 => 20
        })

      visit cart_path

      expect(page).to have_link("Empty Cart")
    end
  end

  context 'as a registered user' do
    it 'shows me all items in my cart' do

    end
  end
end
