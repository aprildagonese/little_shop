require 'rails_helper'

RSpec.describe 'as a merchant' do
  before :each do
    Faker::UniqueGenerator.clear

    @user = create(:user)
    @order = create(:order, user: @user)
    @merchant = create(:merchant)
    @merchant_2 = create(:merchant)

    @item_1 = create(:disabled_item, user: @merchant, quantity: 15, price: 5)
    @item_2, @item_3, @item_4, @item_5, @item_6, @item_7, @item_8, @item_9, @item_10, @item_11, @item_12, @item_13, @item_14, @item_15, @item_16, @item_17, @item_18 = create_list(:item, 17, user: @merchant, quantity: 15, price: 5)

    @order_items = [@item_2, @item_3, @item_4, @item_5, @item_6, @item_7, @item_8, @item_9, @item_10, @item_11, @item_12, @item_13, @item_14, @item_15, @item_16]

    @item_19 = create(:item, user: @merchant_2, quantity: 15, price: 5)

    @order_item_1 = create(:order_item, order: @order, item: @item_1, sale_price: 4, quantity: 5, fulfillment_status: 0)
    @order_item_2 = create(:order_item, order: @order, item: @item_2, sale_price: 4, quantity: 5, fulfillment_status: 0)
    @order_item_3 = create(:order_item, order: @order, item: @item_3, sale_price: 4, quantity: 5, fulfillment_status: 0)
    @order_item_4 = create(:order_item, order: @order, item: @item_4, sale_price: 4, quantity: 5, fulfillment_status: 0)
    @order_item_5 = create(:order_item, order: @order, item: @item_5, sale_price: 4, quantity: 5, fulfillment_status: 0)
    @order_item_6 = create(:order_item, order: @order, item: @item_6, sale_price: 4, quantity: 5, fulfillment_status: 0)
    @order_item_7 = create(:order_item, order: @order, item: @item_7, sale_price: 4, quantity: 5, fulfillment_status: 0)
    @order_item_8 = create(:order_item, order: @order, item: @item_8, sale_price: 4, quantity: 5, fulfillment_status: 0)
    @order_item_9 = create(:order_item, order: @order, item: @item_9, sale_price: 4, quantity: 5, fulfillment_status: 0)
    @order_item_10 = create(:order_item, order: @order, item: @item_10, sale_price: 4, quantity: 5, fulfillment_status: 1)
    @order_item_11 = create(:order_item, order: @order, item: @item_11, sale_price: 4, quantity: 5, fulfillment_status: 1)
    @order_item_12 = create(:order_item, order: @order, item: @item_12, sale_price: 4, quantity: 5, fulfillment_status: 1)
    @order_item_13 = create(:order_item, order: @order, item: @item_13, sale_price: 4, quantity: 5, fulfillment_status: 1)
    @order_item_14 = create(:order_item, order: @order, item: @item_14, sale_price: 4, quantity: 5, fulfillment_status: 2)
    @order_item_15 = create(:order_item, order: @order, item: @item_15, sale_price: 4, quantity: 5, fulfillment_status: 2)
    @order_item_16 = create(:order_item, order: @order, item: @item_16, sale_price: 4, quantity: 5, fulfillment_status: 2)

    login_as(@merchant)
  end

  context 'visiting its items index' do
    it 'can visit dashboard items index' do


      visit dashboard_path

      expect(page).to have_link("My Dishes")
      click_link("My Dishes")

      expect(current_path).to eq(dashboard_items_path)
    end

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

      @order_items.each do |item|
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

    it 'can disable an item' do

      visit dashboard_items_path

      within "#item-#{@item_2.id}" do
        expect(page).to have_button("Disable")
        click_button("Disable")
      end

      expect(current_path).to eq(dashboard_items_path)
      expect(page).to have_content("#{@item_2.title} has been disabled and is no longer for sale.")

      within "#item-#{@item_2.id}" do
        expect(page).to have_content("Item ID: #{@item_2.id} (Disabled)")
        expect(page).to have_button("Enable")
        expect(page).to_not have_button("Disable")
        expect(page).to_not have_button("Delete")
      end
    end

    it 'can enable an item' do

      visit dashboard_items_path

      within "#item-#{@item_1.id}" do
        expect(page).to have_button("Enable")
        click_button("Enable")
      end

      expect(current_path).to eq(dashboard_items_path)
      expect(page).to have_content("#{@item_1.title} has been enabled and is now available for sale.")

      within "#item-#{@item_1.id}" do
        expect(page).to have_content("Item ID: #{@item_1.id}")
        expect(page).to have_button("Disable")
        expect(page).to_not have_button("Enable")
        expect(page).to_not have_button("Delete")
      end
    end

    it 'can delete an item' do

      visit dashboard_items_path

      within "#item-#{@item_17.id}" do
        expect(page).to have_button("Delete")
        click_button("Delete")
      end

      expect(current_path).to eq(dashboard_items_path)
      expect(page).to have_content("#{@item_17.title} has been deleted.")

      expect(page).to_not have_content("Item ID: #{@item_17.id}")
      expect(page).to have_content("Item ID: #{@item_18.id}")
    end

    it 'can add an item' do

      visit dashboard_items_path

      expect(page).to have_button("Add a New Item")
      click_button("Add a New Item")

      expect(current_path).to eq("/dashboard/items/new")

      expect(page).to have_content("Dish")
      expect(page).to have_content("Description")
      expect(page).to have_content("Image (optional)")
      expect(page).to have_content("Price")
      expect(page).to have_content("Inventory")

      expect(page).to have_button("Save Item")

      fill_in "Dish", with: "Delicious Treats"
      fill_in "Description", with: "They're ok"
      fill_in "Image (optional)", with: "http://www.flygirrl.com/uploads/1/4/3/8/14383458/tastytreatsretreat-00_orig.jpg"
      fill_in "Price", with: 20
      fill_in "Current Inventory", with: 40

      click_button("Save Item")

      item_id = Item.last.id

      expect(current_path).to eq(dashboard_items_path)
      expect(page).to have_content("'Delicious Treats' has been saved and is available for sale.")

      within "#item-#{item_id}" do
        expect(page).to have_content("Delicious Treats")
        expect(page).to have_button("Disable")
        expect(page).to_not have_button("Enable")
        expect(page).to have_button("Delete")
      end
    end

    it "can't submit invalid info" do

      visit dashboard_items_new_path

      fill_in "Description", with: "They're ok"
      fill_in "Image (optional)", with: "http://www.flygirrl.com/uploads/1/4/3/8/14383458/tastytreatsretreat-00_orig.jpg"
      fill_in "Price", with: 20
      fill_in "Current Inventory", with: 40

      click_button("Save Item")

      expect(page).to have_content("Enter information for your new dish:")
    end

    it "can leave image blank and get default image" do
    end

    it 'can edit an existing item' do

      visit dashboard_items_path

      within "#item-#{@item_1.id}" do
        click_button "Edit Item"
      end

      expect(current_path).to eq(dashboard_items_edit_path(@item_1))
    end
  end

end
