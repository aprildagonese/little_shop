require 'rails_helper'

RSpec.describe "items", type: :feature do

  context 'as a regular user' do
    it 'should not see all items' do
      visit admin_items_path
      expect(page).to have_content("The page you were looking for doesn't exist")
    end
  end

  context 'admin can manage items on behalf a merchant' do
    before :each do
      Faker::UniqueGenerator.clear

      @user = create(:user)
      @admin = create(:user, role: 2)
      @order = create(:order, user: @user)
      @merchant = create(:merchant)
      @merchant_2 = create(:merchant)

      @item_1 = create(:disabled_item, user: @merchant, quantity: 15, price: 5)
      @item_2, @item_3, @item_17, @item_18 = create_list(:item, 4, user: @merchant, quantity: 15, price: 5)
      @order_items = [@item_2, @item_3]
      @item_19 = create(:item, user: @merchant_2, quantity: 15, price: 5)


      @order_item_1 = create(:order_item, order: @order, item: @item_1, sale_price: 4, quantity: 5, fulfillment_status: 0)
      @order_item_2 = create(:order_item, order: @order, item: @item_2, sale_price: 4, quantity: 5, fulfillment_status: 0)
      @order_item_3 = create(:order_item, order: @order, item: @item_3, sale_price: 4, quantity: 5, fulfillment_status: 0)

      login_as(@admin)
    end

    it 'it can visit merchants profile page items index' do
      visit admin_merchant_path(@merchant)

      expect(page).to have_button("Manage Merchant Items")
      click_button("Manage Merchant Items")

      expect(current_path).to eq(admin_items_path)
      expect(page).to have_content("Merchant #{@merchant.id} (#{@merchant.name}) Dishes")
    end

    it 'sees all of their items' do
      visit admin_items_path(user_id: @merchant)

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
      visit admin_items_path(user_id: @merchant)

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
      visit admin_items_path(user_id: @merchant)

      within "#item-#{@item_2.id}" do
        expect(page).to have_button("Disable")
        click_button("Disable")
      end

      expect(current_path).to eq(admin_items_path)
      expect(page).to have_content("#{@item_2.title} has been disabled and is no longer for sale.")

      within "#item-#{@item_2.id}" do
        expect(page).to have_content("Item ID: #{@item_2.id} (Disabled)")
        expect(page).to have_button("Enable")
        expect(page).to_not have_button("Disable")
        expect(page).to_not have_button("Delete")
      end
    end

    it 'can enable an item' do
      visit admin_items_path(user_id: @merchant)

      within "#item-#{@item_1.id}" do
        expect(page).to have_button("Enable")
        click_button("Enable")
      end

      expect(current_path).to eq(admin_items_path)
      expect(page).to have_content("#{@item_1.title} has been enabled and is now available for sale.")

      within "#item-#{@item_1.id}" do
        expect(page).to have_content("Item ID: #{@item_1.id}")
        expect(page).to have_button("Disable")
        expect(page).to_not have_button("Enable")
        expect(page).to_not have_button("Delete")
      end
    end

    it 'can delete an item' do
      visit admin_items_path(user_id: @merchant)

      within "#item-#{@item_17.id}" do
        expect(page).to have_button("Delete")
        click_button("Delete")
      end

      expect(current_path).to eq(admin_items_path)
      expect(page).to have_content("#{@item_17.title} has been deleted.")

      expect(page).to_not have_content("Item ID: #{@item_17.id}")
      expect(page).to have_content("Item ID: #{@item_18.id}")
    end

    it 'can add an item' do
      visit admin_items_path(user_id: @merchant)

      expect(page).to have_button("Add a New Item")
      click_button("Add a New Item")

      expect(current_path).to eq(new_item_path)

      expect(page).to have_content("Dish")
      expect(page).to have_content("Description")
      expect(page).to have_content("Image (optional)")
      expect(page).to have_content("Price")
      expect(page).to have_content("Inventory")

      expect(page).to have_button("Save Item")

      fill_in "Dish", with: "Delicious Treats"
      fill_in "Description", with: "They're ok"
      fill_in "item[image_url]", with: "http://www.flygirrl.com/uploads/1/4/3/8/14383458/tastytreatsretreat-00_orig.jpg"
      fill_in "Price", with: 20
      fill_in "Current Inventory", with: 40

      click_button("Save Item")

      new_item = Item.last

      expect(new_item.user).to eq(@merchant)

      expect(current_path).to eq(admin_items_path)
      expect(page).to have_content("'Delicious Treats' has been saved and is available for sale.")

      within "#item-#{new_item.id}" do
        expect(page).to have_content("Delicious Treats")
        expect(page).to have_button("Disable")
        expect(page).to_not have_button("Enable")
        expect(page).to have_button("Delete")
      end
    end

    it "can't submit invalid info" do

      visit new_item_path(user: @merchant)

      fill_in "Description", with: "They're ok"
      fill_in "item[image_url]", with: "http://www.flygirrl.com/uploads/1/4/3/8/14383458/tastytreatsretreat-00_orig.jpg"
      fill_in "Price", with: 20
      fill_in "Current Inventory", with: 40

      click_button("Save Item")

      expect(page).to have_content("Enter information\nfor your new dish:")
    end

    it "can't submit invalid description" do

      visit new_item_path(user: @merchant)

      fill_in "Dish", with: "Delicious Treats"
      fill_in "item[image_url]", with: "http://www.flygirrl.com/uploads/1/4/3/8/14383458/tastytreatsretreat-00_orig.jpg"
      fill_in "Price", with: 20
      fill_in "Current Inventory", with: 40

      click_button("Save Item")

      expect(page).to have_content("Enter information\nfor your new dish:")
    end

    it "can't submit invalid price" do

      visit new_item_path(user: @merchant)

      fill_in "Dish", with: "Delicious Treats"
      fill_in "Description", with: "They're ok"
      fill_in "item[image_url]", with: "http://www.flygirrl.com/uploads/1/4/3/8/14383458/tastytreatsretreat-00_orig.jpg"
      fill_in "Current Inventory", with: 40

      click_button("Save Item")

      expect(page).to have_content("Enter information\nfor your new dish:")
    end

    it "can't submit invalid inventory" do

      visit new_item_path(user: @merchant)

      fill_in "Dish", with: "Delicious Treats"
      fill_in "Description", with: "They're ok"
      fill_in "item[image_url]", with: "http://www.flygirrl.com/uploads/1/4/3/8/14383458/tastytreatsretreat-00_orig.jpg"
      fill_in "Price", with: 20

      click_button("Save Item")

      expect(page).to have_content("Enter information\nfor your new dish:")
    end

    it "can leave image blank and get default image" do

      visit new_item_path(user: @merchant)

      fill_in "Dish", with: "Delicious Treats"
      fill_in "Description", with: "They're ok"
      fill_in "Price", with: 20
      fill_in "Current Inventory", with: 40

      click_button("Save Item")

      expect(current_path).to eq(admin_items_path)
      expect(page).to have_content("'Delicious Treats' has been saved and is available for sale.")
      expect(page).to have_css("img[src*='https://2static.fjcdn.com/pictures/Generic+food+image+if+anyones+old+or+watched+repo+man_47b808_5979251.jpg']")
    end

    it "can add new image" do

      visit new_item_path(user: @merchant)

      fill_in "Dish", with: "Delicious Treats"
      fill_in "Description", with: "They're ok"
      fill_in "item[image_url]", with: "https://images.pexels.com/photos/248797/pexels-photo-248797.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"
      fill_in "Price", with: 20
      fill_in "Current Inventory", with: 40

      click_button("Save Item")

      expect(current_path).to eq(admin_items_path)
      expect(page).to have_content("'Delicious Treats' has been saved and is available for sale.")
      expect(page).to have_css("img[src*='https://2static.fjcdn.com/pictures/Generic+food+image+if+anyones+old+or+watched+repo+man_47b808_5979251.jpg']")
    end

    it 'can edit an item' do
      visit admin_items_path(user_id: @merchant)

      within "#item-#{@item_1.id}" do
        expect(page).to have_button("Edit Item")
        click_button("Edit Item")
      end

      expect(current_path).to eq(edit_admin_item_path(@item_1))

      expect(page).to have_content("Dish")
      expect(page).to have_content("Description")
      expect(page).to have_content("Image (optional)")
      expect(page).to have_content("Price")
      expect(page).to have_content("Current Inventory")
      expect(page).to have_button("Update Item")

      fill_in 'Dish', with: 'Okonomiyaki'

      click_button "Update Item"

      expect(current_path).to eq(admin_items_path)

      expect(page).to have_content('Okonomiyaki')
      expect(page).to have_content("'Okonomiyaki' has been updated.")
    end

    it 'is redirected to the edit form if item is entered in error' do
      visit admin_items_path(user_id: @merchant)

      within "#item-#{@item_1.id}" do
        expect(page).to have_button("Edit Item")
        click_button("Edit Item")
      end

      expect(current_path).to eq(edit_admin_item_path(@item_1))

      fill_in 'Dish', with: "#{@item_2.title}"
      fill_in 'Description', with: "good"
      fill_in 'Price', with: 5
      fill_in 'Current Inventory', with: 4

      click_button "Update Item"

      expect(current_path).to eq(edit_admin_item_path(@item_1))

      expect(page).to_not have_content("#{@item_2.title}")
      expect(page).to have_content("Dish title is already taken.")
    end

  end
end
