require 'rails_helper'

RSpec.describe "as a registered user" do
  before :each do
    Faker::UniqueGenerator.clear

    @user = create(:user)
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

    login_as(@user)

    visit profile_orders_path

    click_link "Order ID: #{@order.id}"
  end

  context "when I visit an orders show page" do
    it "sees order information" do
      expect(current_path).to eq(profile_order_path(@order))

      within ".orders-list" do
        expect(page).to have_content("Order ID: #{@order.id}")
        expect(page).to have_content("Placed on: #{@order.created_at}")
        expect(page).to have_content("Last Updated on: #{@order.updated_at}")
        expect(page).to have_content("Item Count: #{@order.item_count}")
        expect(page).to have_content("Order Total: #{@order.total_cost}")
        expect(page).to have_content("Order Status: #{@order.status}")
      end

      within ".order-items" do
        expect(page).to have_content("Order Items:")

        @order_items.each do |order_item|
          within ".id-#{order_item.id}-row" do
            expect(page).to have_css("img[src*='#{order_item.item.image_url}']")
            expect(page).to have_content("#{order_item.item.title}")
            expect(page).to have_content("#{order_item.item.description}")
            expect(page).to have_content("Sale Price: #{order_item.sale_price}")
            expect(page).to have_content("Qty: #{order_item.quantity}")
          end
        end

        within ".id-#{@oi1.id}-row" do
          expect(page).to have_content("Item Subtotal: $10.00")
        end
        within ".id-#{@oi2.id}-row" do
          expect(page).to have_content("Item Subtotal: $15.00")
        end
        within ".id-#{@oi3.id}-row" do
          expect(page).to have_content("Item Subtotal: $20.00")
        end
        within ".id-#{@oi4.id}-row" do
          expect(page).to have_content("Item Subtotal: $25.00")
        end
        within ".id-#{@oi5.id}-row" do
          expect(page).to have_content("Item Subtotal: $30.00")
        end

      end
    end
  end
end
