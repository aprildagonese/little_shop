require 'rails_helper'

RSpec.describe 'as a user', type: :feature do

  before :each do
    Faker::UniqueGenerator.clear

    @user = create(:user, name: "April Test")

    @merchant_1 = create(:user, role: 1)
    @merchant_2 = create(:user, role: 1)
    @merchant_3 = create(:user, role: 1)

    @item_1, @item_2, @item_3 = create_list(:item, 3, user: @merchant_1)
    @item_4, @item_5, @item_6 = create_list(:item, 3, user: @merchant_2)
    @item_7, @item_8, @item_9, @item_10 = create_list(:item, 4, user: @merchant_3)

    @order_1, @order_2, @order_3 =  create_list(:order, 3, user: @user)
    @order_4 = create(:order, user: @user, status: :fulfilled)

    @order_item_1 = create(:order_item, item: @item_1, order: @order_1)
    @order_item_2 = create(:order_item, item: @item_2, order: @order_1)
    @order_item_3 = create(:order_item, item: @item_3, order: @order_1)

    @order_item_4 = create(:order_item, item: @item_4, order: @order_2)
    @order_item_5 = create(:order_item, item: @item_5, order: @order_2)
    @order_item_6 = create(:order_item, item: @item_6, order: @order_2)

    @order_item_7 = create(:order_item, item: @item_7, order: @order_3)
    @order_item_8 = create(:order_item, item: @item_8, order: @order_3)
    @order_item_9 = create(:order_item, item: @item_9, order: @order_3)

    @order_item_10 = create(:order_item, item: @item_10, order: @order_4)

    login_as(@user)

  end

  context 'when visiting profile orders' do

    it 'sees a list of all orders' do

      visit profile_orders_path

      expect(page).to have_content("Your Orders")
      
      within "#order-#{@order_1.id}" do
        expect(page).to have_link("Order ID: #{@order_1.id}")
        expect(page).to have_content("Order Status: #{@order_1.status}")
        expect(page).to have_button("Cancel Order")
        expect(page).to have_content("Placed on: #{@order_1.created_at.to_date.to_s}")
        expect(page).to have_content("Last Updated on: #{@order_1.updated_at.to_date.to_s}")
        expect(page).to have_content("Item Count: #{@order_1.item_count}")
        expect(page).to have_content("Order Total: #{@order_1.total_cost}")
      end

      within "#order-#{@order_2.id}" do
        expect(page).to have_link("Order ID: #{@order_2.id}")
        expect(page).to have_content("Order Status: #{@order_2.status}")
        expect(page).to have_button("Cancel Order")
        expect(page).to have_content("Placed on: #{@order_2.created_at.to_date.to_s}")
        expect(page).to have_content("Last Updated on: #{@order_2.updated_at.to_date.to_s}")
        expect(page).to have_content("Item Count: #{@order_2.item_count}")
        expect(page).to have_content("Order Total: #{@order_2.total_cost}")
      end

      within "#order-#{@order_3.id}" do
        expect(page).to have_link("Order ID: #{@order_3.id}")
        expect(page).to have_content("Order Status: #{@order_3.status}")
        expect(page).to have_button("Cancel Order")
        expect(page).to have_content("Placed on: #{@order_3.created_at.to_date.to_s}")
        expect(page).to have_content("Last Updated on: #{@order_3.updated_at.to_date.to_s}")
        expect(page).to have_content("Item Count: #{@order_3.item_count}")
        expect(page).to have_content("Order Total: #{@order_3.total_cost}")
      end

      within "#order-#{@order_4.id}" do
        expect(page).to have_link("Order ID: #{@order_4.id}")
        expect(page).to have_content("Order Status: #{@order_4.status}")
        expect(page).to_not have_button("Cancel Order")
        expect(page).to have_content("Placed on: #{@order_4.created_at.to_date.to_s}")
        expect(page).to have_content("Last Updated on: #{@order_4.updated_at.to_date.to_s}")
        expect(page).to have_content("Item Count: #{@order_4.item_count}")
        expect(page).to have_content("Order Total: #{@order_4.total_cost}")
      end

    end

    it 'can visit order show page by clicking id' do

      visit profile_orders_path

      click_link "Order ID: #{@order_1.id}"

      expect(current_path).to eq(profile_order_path(@order_1))

    end

    it 'can cancel a pending order' do

      visit profile_orders_path

      within "#order-#{@order_1.id}" do
        click_button "Cancel Order"
      end

      within "#order-#{@order_1.id}" do
        expect(page).to have_content("Order Status: cancelled")
      end

    end

  end

end
