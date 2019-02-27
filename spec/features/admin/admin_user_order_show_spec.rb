require 'rails_helper'

RSpec.describe 'as an admin', type: :feature do

  before :each do
    Faker::UniqueGenerator.clear

    @user = create(:user)
    @merchant = create(:user, role: 1)
    @admin = create(:user, role: 2)
    @order_1 = create(:order, user: @user)
    @order_2 = create(:order, user: @user)
    @order_3 = create(:order, user: @user, status: 1)
    @i1, @i2, @i3, @i4, @i5, @i6 = create_list(:item, 6, user: @merchant, quantity: 20)
    @oi1, @oi2, @oi3, @oi4, @oi5, @oi6 = create_list(:order_item, 6)
    @oi1.update(order: @order_1, item: @i1, sale_price: 2, quantity: 5)
    @oi2.update(order: @order_1, item: @i2, sale_price: 3, quantity: 5, fulfillment_status: 1)
    @oi3.update(order: @order_2, item: @i3, sale_price: 4, quantity: 5)
    @oi4.update(order: @order_2, item: @i4, sale_price: 5, quantity: 5)
    @oi5.update(order: @order_3, item: @i5, sale_price: 6, quantity: 5)
    @oi6.update(order: @order_3, item: @i6, sale_price: 7, quantity: 5)
    @order_items = [@oi1, @oi2, @oi3, @oi4, @oi5, @oi6]

    login_as(@admin)
  end

  context "when I visit a users orders show page" do
    it "sees order information" do
      visit admin_order_path(@order_1)

      expect(current_path).to eq("/admin/orders/#{@order_1.id}")

      within "#order-#{@order_1.id}" do
        expect(page).to have_content("Order ID: #{@order_1.id}")
        expect(page).to have_content("Placed on: #{@order_1.created_at}")
        expect(page).to have_content("Last Updated on: #{@order_1.updated_at}")
        expect(page).to have_content("Item Count: #{@order_1.item_count}")
        expect(page).to have_content("Order Total: $#{@order_1.total_cost}.00")
        expect(page).to have_content("Order Status: Pending")
      end

      within ".order-items" do
        expect(page).to have_content("Order Items:")

        within ".id-#{@oi1.id}-row" do
          expect(page).to have_css("img[src*='#{@oi1.item.image_url}']")
          expect(page).to have_content("#{@oi1.item.title}")
          expect(page).to have_content("#{@oi1.item.description}")
          expect(page).to have_content("Sale Price: $2.00")
          expect(page).to have_content("Qty: #{@oi1.quantity}")
          expect(page).to have_content("Item Subtotal: $10.00")
        end

        within ".id-#{@oi2.id}-row" do
          expect(page).to have_css("img[src*='#{@oi2.item.image_url}']")
          expect(page).to have_content("#{@oi2.item.title}")
          expect(page).to have_content("#{@oi2.item.description}")
          expect(page).to have_content("Sale Price: $3.00")
          expect(page).to have_content("Qty: #{@oi2.quantity}")
          expect(page).to have_content("Item Subtotal: $15.00")
        end
      end

      expect(page).to_not have_content("Order ID: #{@order_2.id}")

      expect(page).to_not have_content("Order ID: #{@order_3.id}")

    end

    context "if order is pending" do
      it "sees cancel order button" do
        visit admin_order_path(@order_1)

        expect(page).to have_button("Cancel Order")
      end

      it "can cancel order" do
        visit admin_user_path(@user.slug)

        click_button 'User Orders'

        within "#order-#{@order_1.id}" do
          expect(page).to have_content("Order ID: #{@order_1.id}")
          expect(page).to have_content("Order Status: Pending")
        end

        within "#order-#{@order_2.id}" do
          expect(page).to have_content("Order ID: #{@order_2.id}")
          expect(page).to have_content("Order Status: Pending")
        end

        within "#order-#{@order_3.id}" do
          expect(page).to have_content("Order ID: #{@order_3.id}")
          expect(page).to have_content("Order Status: Fulfilled")
        end

        click_link("Order ID: #{@order_1.id}")

        expect(current_path).to eq(admin_order_path(@order_1))

        within "#order-#{@order_1.id}" do
          expect(page).to have_content("Order ID: #{@order_1.id}")
          expect(page).to have_content("Order Status: Pending")
        end

        within ".id-#{@oi1.id}-row" do
          expect(page).to have_content("Qty: 5")
          expect(page).to have_content("Item Status: Pending")
        end

        within ".id-#{@oi2.id}-row" do
          expect(page).to have_content("Qty: 5")
          expect(page).to have_content("Item Status: Fulfilled")
        end

        expect(@i1.quantity).to eq(20)
        expect(@i2.quantity).to eq(20)

        click_button("Cancel Order")

        expect(current_path).to eq(admin_orders_path)

        expect(page).to have_content("Order #{@order_1.id} has been cancelled.")
        expect(page).to have_content("User Orders")

        within "#order-#{@order_1.id}" do
          expect(page).to have_content("Order ID: #{@order_1.id}")
          expect(page).to have_content("Order Status: Cancelled")
        end

        within "#order-#{@order_2.id}" do
          expect(page).to have_content("Order ID: #{@order_2.id}")
          expect(page).to have_content("Order Status: Pending")
        end

        within "#order-#{@order_3.id}" do
          expect(page).to have_content("Order ID: #{@order_3.id}")
          expect(page).to have_content("Order Status: Fulfilled")
        end

        click_link("Order ID: #{@order_1.id}")

        expect(current_path).to eq(admin_order_path(@order_1))

        within "#order-#{@order_1.id}" do
          expect(page).to have_content("Order ID: #{@order_1.id}")
          expect(page).to have_content("Order Status: Cancelled")
        end

        within ".id-#{@oi1.id}-row" do
          expect(page).to have_content("Qty: 5")
          expect(page).to have_content("Item Status: Unfulfilled")
        end

        within ".id-#{@oi2.id}-row" do
          expect(page).to have_content("Qty: 5")
          expect(page).to have_content("Item Status: Unfulfilled")
        end

        click_link("Browse Dishes")

        within ".id-#{@i1.id}-row" do
          expect(page).to have_content("Qty: 20")
        end

        within ".id-#{@i2.id}-row" do
          expect(page).to have_content("Qty: 25")
        end

        expect(page).to_not have_button("Cancel Order")
      end
    end

    context "if order is not pending" do
      it "doesn't see cancel order button" do
        visit admin_order_path(@order_3)

        expect(page).to have_content("Order Status: Fulfilled")
        expect(page).to_not have_button("Cancel Order")
      end
    end

  end
end
