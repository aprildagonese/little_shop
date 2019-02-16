require 'rails_helper'

RSpec.describe 'Cart show page' do
  before :each do
    @item_1 = create(:item, price: 20, quantity: 5)
    @item_2 = create(:item, price: 1, quantity: 10)
    @item_3 = create(:item)
  end
  context 'as a visitor' do
    it 'I see all items in my cart' do
      visit item_path(@item_1)
      click_button "Add Item To Cart"
      visit item_path(@item_2)
      click_button "Add Item To Cart"

      visit cart_path

      expect(page).to have_content("Grand Total: $110")
      expect(page).to have_link("Empty Cart")

      within ".id-#{@item_1.id}-row" do
        expect(page).to have_content(@item_1.title)
        expect(page).to have_css("img[src*='#{@item_1.image_url}']")
        expect(page).to have_content("Sold By: #{@item_1.user.name}")
        expect(page).to have_content("Current Price: $#{@item_1.price}")
        expect(page).to have_content("Desired Quantity: #{@item_1.quantity}")
        expect(page).to have_content("Subtotal: $#{@item_1.subtotal}")
      end
      within ".id-#{@item_2.id}-row" do
        expect(page).to have_content(@item_2.title)
        expect(page).to have_css("img[src*='#{@item_2.image_url}']")
        expect(page).to have_content("Sold By: #{@item_2.user.name}")
        expect(page).to have_content("Current Price: $#{@item_2.price}")
        expect(page).to have_content("Desired Quantity: #{@item_2.quantity}")
        expect(page).to have_content("Subtotal: $#{@item_2.subtotal}")
      end

      within '.item-list' do
        expect(page).to_not have_content(@item_3.title)
        expect(page).to_not have_content("Sold By: #{@item_3.user.name}")
        expect(page).to_not have_content("Current Price: $#{@item_3.price}")
        expect(page).to_not have_content("Desired Quantity: #{@item_3.quantity}")
        expect(page).to_not have_content("Subtotal: $#{@item_3.subtotal}")
      end
    end
  end

  context 'as a registered user' do
    it 'I see all items in my cart' do
      user = create(:user, role: 0)
      login_as(user)
      visit item_path(@item_1)
      click_button "Add Item To Cart"
      visit item_path(@item_2)
      click_button "Add Item To Cart"

      visit cart_path

      expect(page).to have_content("Grand Total: $110")
      expect(page).to have_link("Empty Cart")

      within ".id-#{@item_1.id}-row" do
        expect(page).to have_content(@item_1.title)
        expect(page).to have_css("img[src*='#{@item_1.image_url}']")
        expect(page).to have_content("Sold By: #{@item_1.user.name}")
        expect(page).to have_content("Current Price: $#{@item_1.price}")
        expect(page).to have_content("Desired Quantity: #{@item_1.quantity}")
        expect(page).to have_content("Subtotal: $#{@item_1.subtotal}")
      end
      within ".id-#{@item_2.id}-row" do
        expect(page).to have_content(@item_2.title)
        expect(page).to have_css("img[src*='#{@item_2.image_url}']")
        expect(page).to have_content("Sold By: #{@item_2.user.name}")
        expect(page).to have_content("Current Price: $#{@item_2.price}")
        expect(page).to have_content("Desired Quantity: #{@item_2.quantity}")
        expect(page).to have_content("Subtotal: $#{@item_2.subtotal}")
      end

      within '.item-list' do
        expect(page).to_not have_content(@item_3.title)
        expect(page).to_not have_content("Sold By: #{@item_3.user.name}")
        expect(page).to_not have_content("Current Price: $#{@item_3.price}")
        expect(page).to_not have_content("Desired Quantity: #{@item_3.quantity}")
        expect(page).to_not have_content("Subtotal: $#{@item_3.subtotal}")
      end
    end
  end

  context "when I haven't added items to my cart" do
    it "my cart contains no items" do
      visit cart_path

      expect(page).to have_content("Your cart is currently empty.")
      expect(page).to_not have_content("Empty Cart")
    end
  end

  context "after adding items to my cart" do
    it "I can empty it" do
      visit item_path(@item_1)
      click_button "Add Item To Cart"
      visit item_path(@item_2)
      click_button "Add Item To Cart"
      expect(page).to have_link("Cart (2)")
      visit cart_path

      click_link("Empty Cart")
      
      expect(page).to have_content("Your cart is currently empty.")
      expect(page).to_not have_content("Empty Cart")
    end
  end
end
