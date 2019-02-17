require 'rails_helper'

RSpec.describe "as a registered user" do
  before :each do
    Faker::UniqueGenerator.clear

    @user = create(:user)
    @merchant = create(:user, role: 1)
    @order = create(:order, user: @user)
    @i1, @i2, @i3, @i4, @i5 = create_list(:item, 5, user: @merchant)
    @oi1, @oi2, @oi3, @oi4, @oi5 = create_list(:order_item, 5)
    @oi1.update(order: @order, item: @i1)
    @oi2.update(order: @order, item: @i2)
    @oi3.update(order: @order, item: @i3)
    @oi4.update(order: @order, item: @i4)
    @oi5.update(order: @order, item: @i5)
    @order_items = [@oi1, @oi2, @oi3, @oi4, @oi5]

    login_as(@user)

    visit profile_orders_path(@order)

    click_link "Order ID: #{@order.id}"
  end

  context "When I visit an orders show page" do
    it "sees order information" do
      expect(current_path).to eq(profile_orders_path(@order))

      within ".order-info" do
        expect(page).to have_content("Order ID: #{@order.id}")
        expect(page).to have_content("Started on: #{@order.created_at}")
        expect(page).to have_content("Last Updated on: #{@order.updated_at}")
        expect(page).to have_content("Item Count: #{@order.item_count}")
        expect(page).to have_content("Order Total: #{@order.total_cost}")
        expect(page).to have_content("Order Status: #{@order.status}")
      end

      within ".order-items" do
        expect(page).to have_content("Order Items:")

        @order_items.each do |order_item|
          within ".id-#{order_item.id}-row" do
            expect(page).to have_content("#{order_item.item.image_url}")
            expect(page).to have_content("#{order_item.item.title}")
            expect(page).to have_content("#{order_item.item.description}")
            expect(page).to have_content("Sale Price: #{order_item.sale_price}")
            expect(page).to have_content("Qty: #{order_item.quantity}")
            expect(page).to have_content("Item Subtotal: #{order_item.subtotal}")
          end
        end
      end
    end
  end
end
