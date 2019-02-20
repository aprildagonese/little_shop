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
    it 'should add an item to an empty cart' do
      cart = Cart.new({})

      cart.add_item(1)
      expect(cart.contents).to eq({1 => 1})

      cart.add_item(2)
      expect(cart.contents).to eq({1 => 1, 2 => 1})
    end
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

  describe '#grand_total' do
    it 'should add up all subtotals in the cart' do
      item_1 = create(:item, price: 20, quantity: 50)
      item_2 = create(:item, price: 1, quantity: 10)

      cart = Cart.new({
        item_1.id.to_s => 20,
        item_2.id.to_s => 10
        })

      expect(cart.grand_total).to eq(410)
    end
  end

  describe '#subtotal' do
    it 'finds and item\'s price and multiplies by cart\'s quantity for that item\'s id' do
      item_1 = create(:item, price: 20, quantity: 50)
      item_2 = create(:item, price: 1, quantity: 10)

      cart = Cart.new({
        item_1.id.to_s => 20,
        item_2.id.to_s => 10
        })

      expect(cart.subtotal(item_1.id)).to eq(400)
    end
  end

end
