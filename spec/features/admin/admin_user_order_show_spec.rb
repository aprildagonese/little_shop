require 'rails_helper'

RSpec.describe 'as an admin', type: :feature do

  before :each do
    Faker::UniqueGenerator.clear

    @user = create(:user)
    @merchant = create(:user, role: 1)
    @admin = create(:user, role: 2)
    @order_1 = create(:order, user: @user)
    @order_2 = create(:order, user: @user, status: 1)
    @i1, @i2, @i3, @i4, @i5 = create_list(:item, 5, user: @merchant)
    @oi1, @oi2, @oi3, @oi4, @oi5 = create_list(:order_item, 5)
    @oi1.update(order: @order_1, item: @i1, sale_price: 2, quantity: 5)
    @oi2.update(order: @order_1, item: @i2, sale_price: 3, quantity: 5)
    @oi3.update(order: @order_1, item: @i3, sale_price: 4, quantity: 5)
    @oi4.update(order: @order_2, item: @i4, sale_price: 5, quantity: 5)
    @oi5.update(order: @order_2, item: @i5, sale_price: 6, quantity: 5)
    @order_items = [@oi1, @oi2, @oi3, @oi4, @oi5]

    login_as(@admin)
  end

  context "when I visit a users orders show page" do
    it "sees order information" do
      visit admin_order_path(@order_1)

      within ".orders-list" do
        expect(page).to have_content("Order ID: #{@order_1.id}")
        expect(page).to have_content("Placed on: #{@order_1.created_at}")
        expect(page).to have_content("Last Updated on: #{@order_1.updated_at}")
        expect(page).to have_content("Item Count: #{@order_1.item_count}")
        expect(page).to have_content("Order Total: #{@order_1.total_cost}")
        expect(page).to have_content("Order Status: #{@order_1.status}")
      end
    end

    context "if order is pending" do
      it "sees cancel order button" do
        visit admin_order_path(@order_1)

        expect(page).to have_button("Cancel Order")
      end

      it "can cancel order" do
        visit admin_order_path(@order_1)

        click_button("Cancel Order")

        expect(current_path).to eq(admin_orders_path)
      end
    end

    context "if order is not pending" do
      it "doesn't see cancel order button" do
        visit admin_order_path(@order_2)

        expect(page).to_not have_button("Cancel Order")
      end
    end

  end
end
