require 'rails_helper'

RSpec.describe 'as a merchant' do
  before :each do
    Faker::UniqueGenerator.clear

    @user_1 = create(:user)

    @order_1 = create(:order, user: @user_1)

    @merchant = create(:merchant)
    @other_merchant = create(:merchant)

    @item_1 = create(:disabled_item, user: @merchant)

    @item_2, @item_3, @item_4, @item_5, @item_6, @item_7, @item_8, @item_9, @item_10, @item_11, @item_12, @item_13, @item_14, @item_15, @item_16, @item_17, @item_18 = create_list(:item, 17, user: @merchant)

    @ordered_items = [@item_2, @item_3, @item_4, @item_5, @item_6, @item_7, @item_8, @item_9, @item_10, @item_11, @item_12, @item_13, @item_14, @item_15, @item_16]

    @item_19 = create(:item, user: @other_merchant)

    @order_item_1 = create(:order_item, order: @order_1, item: @item_1)
    @order_item_2 = create(:order_item, order: @order_1, item: @item_2)
    @order_item_3 = create(:order_item, order: @order_1, item: @item_3)
    @order_item_4 = create(:order_item, order: @order_1, item: @item_4)
    @order_item_5 = create(:order_item, order: @order_1, item: @item_5)
    @order_item_6 = create(:order_item, order: @order_1, item: @item_6)
    @order_item_7 = create(:order_item, order: @order_1, item: @item_7)
    @order_item_8 = create(:order_item, order: @order_1, item: @item_8)
    @order_item_9 = create(:order_item, order: @order_1, item: @item_9)
    @order_item_10 = create(:order_item, order: @order_1, item: @item_10)
    @order_item_11 = create(:order_item, order: @order_1, item: @item_11)
    @order_item_12 = create(:order_item, order: @order_1, item: @item_12)
    @order_item_13 = create(:order_item, order: @order_1, item: @item_13)
    @order_item_14 = create(:order_item, order: @order_1, item: @item_14)
    @order_item_15 = create(:order_item, order: @order_1, item: @item_15)
    @order_item_16 = create(:order_item, order: @order_1, item: @item_16)

    login_as(@merchant)

  end

  context 'visiting it\'s items index' do
    it 'sees all of their items' do

      visit dashboard_items_path

      @merchant.items.each do |item|
        within "#item-#{item.id}" do
          expect(page).to have_content("Item ID: #{item.id}")
          expect(page).to have_content(item.title)
          expect(page).to have_css("img[src*='#{item.image_url}']")
          expect(page).to have_content("Price: #{item.price}")
          expect(page).to have_content("Inventory: #{item.quantity}")
          expect(page).to have_button("Edit Item")
        end
      end

      expect(page).to_not have_content("Item ID: #{@item_19.id}")
      expect(page).to_not have_content(@item_19.title)

    end

    it 'sees a button to enable/disable' do

      visit dashboard_items_path

      within "#item-#{@item_1.id}" do
        expect(page).to have_button("Enable")
        expect(page).to_not have_button("Disable")
        expect(page).to_not have_button("Delete")
      end

      @ordered_items.each do |item|
        within "#item-#{item.id}" do
          expect(page).to have_button("Disable")
          expect(page).to_not have_button("Enable")
          expect(page).to_not have_button("Delete")
        end
      end

      within "#item-#{@item_17.id}" do
        expect(page).to_not have_button("Enable")
        expect(page).to have_button("Disable")
        expect(page).to have_button("Delete")
      end

      within "#item-#{@item_18.id}" do
        expect(page).to_not have_button("Enable")
        expect(page).to have_button("Disable")
        expect(page).to have_button("Delete")
      end

    end
  end
end
