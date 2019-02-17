require 'rails_helper'

RSpec.describe "as an admin" do
  before :each do
    Faker::UniqueGenerator.clear

    @admin = create(:user, role: 2)
    @merchant = create(:user, role: 1)
    @order = create(:order, user: @user)
    @i1, @i2, @i3, @i4, @i5 = create_list(:item, 5, user: @merchant)
    @oi1, @oi2, @oi3, @oi4, @oi5 = create_list(:order_item, 5)
    @oi1.update(order: @order, item: @i1, sale_price: 2, quantity: 5)
    @oi2.update(order: @order, item: @i2, sale_price: 3, quantity: 5)
    @oi3.update(order: @order, item: @i3, sale_price: 4, quantity: 5)
    @oi4.update(order: @order, item: @i4, sale_price: 5, quantity: 5)
    @oi5.update(order: @order, item: @i5, sale_price: 6, quantity: 5)
    @order_items = [@oi1, @oi2, @oi3, @oi4, @oi5]

    login_as(@admin)

    #visit "/admin/users/5/orders"
    #visit profile_orders_path

    #go to "/admin/users/5/orders/6"
    #click_link "Order ID: #{@order.id}"
  end

  context "when I visit a users orders show page" do
    xit "sees order information" do
      expect(current_path).to eq(profile_order_path(@order))

      within ".orders-list" do
        expect(page).to have_content("Order ID: #{@order.id}")
        expect(page).to have_content("Started on: #{@order.created_at}")
        expect(page).to have_content("Last Updated on: #{@order.updated_at}")
        expect(page).to have_content("Item Count: #{@order.item_count}")
        expect(page).to have_content("Order Total: #{@order.total_cost}")
        expect(page).to have_content("Order Status: #{@order.status}")
      end
    end

    context "if order is pending" do
      xit "sees cancel order button" do
      end

      xit "can cancel order" do
      end
    end

    context "if order is not pending" do
      xit "doesn't see cancel order button" do
      end
    end

  end
end
