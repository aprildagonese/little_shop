require 'rails_helper'

RSpec.describe "as a merchant" do
  context "if the item has already been fulfilled" do
    it "it is listed as fulfilled" do
      Faker::UniqueGenerator.clear
      @user = create(:user)
      @merchant = create(:user, role: 1)
      @merchant_2 = create(:user, role: 1)
      @order = create(:order, user: @user)
      @i1, @i2, @i3 = create_list(:item, 3, user: @merchant, quantity: 5, price: 5)
      @i4, @i5 = create_list(:item, 2, user: @merchant_2, quantity: 5, price: 5)
      @oi1, @oi2, @oi3, @oi4, @oi5 = create_list(:order_item, 5)
      @oi1.update(order: @order, item: @i1, sale_price: 2, quantity: 5)
      @oi2.update(order: @order, item: @i2, sale_price: 3, quantity: 5, fulfillment_status: 1)
      @oi3.update(order: @order, item: @i3, sale_price: 4, quantity: 3)
      @oi4.update(order: @order, item: @i4, sale_price: 5, quantity: 6)
      @oi5.update(order: @order, item: @i5, sale_price: 6, quantity: 6)
      @order_items = [@oi1, @oi2, @oi3, @oi4, @oi5]

      login_as(@merchant)
      visit dashboard_order_path(@order)

      within ".item-#{@oi1.id}" do
        expect(page).to have_button("Fulfill Item")
      end
      within ".item-#{@oi2.id}" do
        expect(page).to_not have_button("Fulfill Item")
      end
      within ".item-#{@oi3.id}" do
        expect(page).to have_button("Fulfill Item")
      end
    end
  end
  context "when I do not have enough in-stock quantity" do
    it 'I can not fulfill an order-item' do
      Faker::UniqueGenerator.clear
      @user = create(:user)
      @merchant = create(:user, role: 1)
      @merchant_2 = create(:user, role: 1)
      @order = create(:order, user: @user)
      @i1, @i2, @i3 = create_list(:item, 3, user: @merchant, quantity: 5, price: 5)
      @i4, @i5 = create_list(:item, 2, user: @merchant_2, quantity: 5, price: 5)
      @oi1, @oi2, @oi3, @oi4, @oi5 = create_list(:order_item, 5)
      @oi1.update(order: @order, item: @i1, sale_price: 2, quantity: 5)
      @oi2.update(order: @order, item: @i2, sale_price: 3, quantity: 5, fulfillment_status: 1)
      @oi3.update(order: @order, item: @i3, sale_price: 4, quantity: 3)
      @oi4.update(order: @order, item: @i4, sale_price: 5, quantity: 6)
      @oi5.update(order: @order, item: @i5, sale_price: 6, quantity: 6)
      @order_items = [@oi1, @oi2, @oi3, @oi4, @oi5]

      login_as(@merchant)
      visit dashboard_order_path(@order)

      within ".item-#{@oi4.id}" do
        expect(page).to_not have_button("Fulfill Item")
      end
      within ".item-#{@oi5.id}" do
        expect(page).to_not have_button("Fulfill Item")
      end
    end
  end

  context "when I have the quantity in stock, I can fulfill an item" do
    it "by changing the oi status and reducing the item's quantity" do
      Faker::UniqueGenerator.clear
      @user = create(:user)
      @merchant = create(:user, role: 1)
      @merchant_2 = create(:user, role: 1)
      @order = create(:order, user: @user)
      @i1, @i2, @i3 = create_list(:item, 3, user: @merchant, quantity: 5, price: 5)
      @i4, @i5 = create_list(:item, 2, user: @merchant_2, quantity: 5, price: 5)
      @oi1, @oi2, @oi3, @oi4, @oi5 = create_list(:order_item, 5)
      @oi1.update(order: @order, item: @i1, sale_price: 2, quantity: 5)
      @oi2.update(order: @order, item: @i2, sale_price: 3, quantity: 5, fulfillment_status: 1)
      @oi3.update(order: @order, item: @i3, sale_price: 4, quantity: 3)
      @oi4.update(order: @order, item: @i4, sale_price: 5, quantity: 6)
      @oi5.update(order: @order, item: @i5, sale_price: 6, quantity: 6)
      @order_items = [@oi1, @oi2, @oi3, @oi4, @oi5]

      login_as(@merchant)
      visit dashboard_order_path(@order)

      within ".item-#{@oi1.id}" do
        click_button "Fulfill Item"
      end
        expect(current_path).to eq(dashboard_order_path(@order))
        expect(@oi1.item.quantity).to eq(0)
        expect(@oi1.fulfilled?).to eq(true)
        expect(page).to have_content("Your item has been fulfilled.")
      within ".item-#{@oi1.id}" do
        expect(page).to have_content("Order Item Status: Fulfilled")
      end

      within ".item-#{@oi3.id}" do
        click_button "Fulfill Item"
      end
        expect(current_path).to eq(dashboard_order_path(@order))
        expect(@oi3.item.quantity).to eq(2)
        expect(@oi3.fulfilled?).to eq(true)
        expect(page).to have_content("Your item has been fulfilled.")
      within ".item-#{@oi3.id}" do
        expect(page).to have_content("Order Item Status: Fulfilled")
      end
    end
  end
end
