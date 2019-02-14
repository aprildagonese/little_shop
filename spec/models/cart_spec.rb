require 'rails_helper'

RSpec.describe Cart do
  describe '#total_count' do
    it 'can calculate the total number of items it holds' do
    cart = Cart.new({
        1 => 2,
        2 => 3
        })

      expect(cart.total_count).to eq(5)
    end
  end

  describe '#add_item' do
    it 'should add an item to our cart' do
      cart = Cart.new({
        1 => 2,
        2 => 3
        })

      cart.add_item(1)
      cart.add_item(2)

      expect(cart.contents).to eq({1 => 3, 2 => 4})
    end
  end

<<<<<<< HEAD
=======
  describe '.grand_total' do
    it 'should add up all subtotals in the cart' do
      item_1 = create(:item, price: 20, quantity: 5)
      item_2 = create(:item, price: 1, quantity: 10)

      cart = Cart.new({
        1 => 20,
        2 => 10
        })

        expect(cart.grand_total).to eq(110)
    end
  end

>>>>>>> 996ce9d829e6c1ad36d201a5c501dbb0a4d946e9
end
