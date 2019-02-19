require 'rails_helper'

RSpec.describe "as a merchant" do
  before :each do
    Faker::UniqueGenerator.clear

    @user = create(:user)
    @merchant = create(:user, role: 1)
    @merchant_2 = create(:user, role: 1)
    @order = create(:order, user: @user)
    @i1, @i2, @i3 = create_list(:item, 3, user: @merchant, quantity: 10, price: 5)
    @i4, @i5 = create_list(:item, 2, user: @merchant_2, quantity: 10, price: 5)
    @oi1, @oi2, @oi3, @oi4, @oi5 = create_list(:order_item, 5)
    @oi1.update(order: @order, item: @i1, sale_price: 2, quantity: 5)
    @oi2.update(order: @order, item: @i2, sale_price: 3, quantity: 5)
    @oi3.update(order: @order, item: @i3, sale_price: 4, quantity: 5)
    @oi4.update(order: @order, item: @i4, sale_price: 5, quantity: 5)
    @oi5.update(order: @order, item: @i5, sale_price: 6, quantity: 5)
    @order_items = [@oi1, @oi2, @oi3, @oi4, @oi5]

    login_as(@merchant)

    visit dashboard_order_path(@order)
  end

  context "when I visit an order show page" do
    it 'I see customer info' do
      expect(current_path).to eq("/dashboard/orders/#{@order.id}")

      within ".merchant-order-customer_info" do
        expect(page).to have_content("Customer: #{@user.name}")
        expect(page).to have_content("Shipping to: #{@user.street_address},
                                                  #{@user.city},
                                                  #{@user.state},
                                                  #{@user.zip_code}")
      end

      within ".merchant-order-items" do
        within ".item-#{@oi1.id}" do
          expect(page).to have_link("#{@oi1.item.title}")
          expect(page).to have_css("img[src*='#{@oi1.item.image_url}']")
          expect(page).to have_content("Price: $#{@oi1.sale_price}.00")
          expect(page).to have_content("Qty: #{@oi1.quantity}")
          expect(page).to have_content("Item Subtotal: $#{@order.total_cost}.00")
          expect(page).to have_content("Order Status: Pending")
        end
        within ".item-#{@oi2.id}" do
          expect(page).to have_link("#{@oi2.item.title}")
          expect(page).to have_css("img[src*='#{@oi2.item.image_url}']")
          expect(page).to have_content("Price: $#{@oi2.sale_price}.00")
          expect(page).to have_content("Qty: #{@oi2.quantity}")
          expect(page).to have_content("Item Subtotal: $#{@order.total_cost}.00")
          expect(page).to have_content("Order Status: Pending")
        end
        within ".item-#{@oi3.id}" do
          expect(page).to have_link("#{@oi3.item.title}")
          expect(page).to have_css("img[src*='#{@oi3.item.image_url}']")
          expect(page).to have_content("Price: $#{@oi3.sale_price}.00")
          expect(page).to have_content("Qty: #{@oi3.quantity}")
          expect(page).to have_content("Item Subtotal: $#{@order.total_cost}.00")
          expect(page).to have_content("Order Status: Pending")
        end
      end

      expect(page).to_not have_content(@oi4.item.title)
      expect(page).to_not have_content(@oi5.item.title)
    end
  end

end
