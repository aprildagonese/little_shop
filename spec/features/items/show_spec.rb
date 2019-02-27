require 'rails_helper'

RSpec.describe 'when it visits an items show page' do

  before :each do
    Faker::UniqueGenerator.clear
  end

  context 'As a visitor' do
    it 'can see all enabled items' do
      merchant = create(:user, role: 1)
      item = create(:item, user: merchant)
      order_1 = create(:order, status: 1)
      order_2 = create(:order, status: 1)
      order_3 = create(:order, status: 1)
      create(:order_item, item: item, order: order_1, sale_price: 5, created_at: 10000.minutes.ago, updated_at: 1.day.ago)
      create(:order_item, item: item, order: order_2, sale_price: 5, created_at: 20000.minutes.ago, updated_at: 1.day.ago)
      create(:order_item, item: item, order: order_3, sale_price: 5, created_at: 30000.minutes.ago, updated_at: 1.day.ago)

      visit item_path(item.slug)

      expect(current_path).to eq(item_path(item.slug))
      expect(page).to have_content(item.title)
      expect(page).to have_content(item.description)
      expect(page).to have_css("img[src*='#{item.image_url}']")
      expect(page).to have_content("Sold By: #{item.user.name}")
      expect(page).to have_content("Qty In Stock: #{item.quantity}")
      expect(page).to have_content("Current Price: $#{item.price}")
      expect(page).to have_content("Average fulfillment time: 12 days, 21 hours")
    end

    it 'can see a link to add item to cart' do
      merchant = create(:user, role: 1)
      item = create(:item, user: merchant)

      visit item_path(item.slug)

      expect(page).to have_button("Add Item To Cart")
    end
  end

  context 'As a user' do

    it 'can see all enabled items' do
      user = create(:user)
      login_as(user)

      merchant = create(:user, role: 1)
      item = create(:item, user: merchant)

      visit item_path(item.slug)

      expect(current_path).to eq(item_path(item.slug))
      expect(page).to have_content(item.title)
      expect(page).to have_content(item.description)
      expect(page).to have_css("img[src*='#{item.image_url}']")
      expect(page).to have_content("Sold By: #{item.user.name}")
      expect(page).to have_content("Qty In Stock: #{item.quantity}")
      expect(page).to have_content("Current Price: $#{item.price}")
      expect(page).to have_content("Average fulfillment time: n/a")
    end

    it 'can see a link to add item to cart' do
      user = create(:user)
      login_as(user)

      merchant = create(:user, role: 1)
      item = create(:item, user: merchant)

      visit item_path(item.slug)

      expect(page).to have_button("Add Item To Cart")
    end
  end

  context 'As a merchant' do

    it 'can see all enabled items' do
      user = create(:user, role: 1)
      login_as(user)

      merchant = create(:user, role: 1)
      item = create(:item, user: merchant)

      visit item_path(item.slug)

      expect(current_path).to eq(item_path(item.slug))
      expect(page).to have_content(item.title)
      expect(page).to have_content(item.description)
      expect(page).to have_css("img[src*='#{item.image_url}']")
      expect(page).to have_content("Sold By: #{item.user.name}")
      expect(page).to have_content("Qty In Stock: #{item.quantity}")
      expect(page).to have_content("Current Price: $#{item.price}")
      expect(page).to have_content("Average fulfillment time: n/a")
    end

    it 'cant see a link to add item to cart' do
      user = create(:user, role: 1)
      login_as(user)

      merchant = create(:user, role: 1)
      item = create(:item, user: merchant)

      visit item_path(item.slug)

      expect(page).to_not have_link("Add Item To Cart")
    end
  end

  context 'As an admin' do

    it 'can see all enabled items' do
      user = create(:user, role: 2)
      login_as(user)

      merchant = create(:user, role: 1)
      item = create(:item, user: merchant)

      visit item_path(item.slug)

      expect(current_path).to eq(item_path(item.slug))
      expect(page).to have_content(item.title)
      expect(page).to have_content(item.description)
      expect(page).to have_css("img[src*='#{item.image_url}']")
      expect(page).to have_content("Sold By: #{item.user.name}")
      expect(page).to have_content("Qty In Stock: #{item.quantity}")
      expect(page).to have_content("Current Price: $#{item.price}")
      expect(page).to have_content("Average fulfillment time: n/a")
    end

    it 'cant see a link to add item to cart' do
      user = create(:user, role: 2)
      login_as(user)

      merchant = create(:user, role: 1)
      item = create(:item, user: merchant)

      visit item_path(item.slug)

      expect(page).to_not have_link("Add Item To Cart")
    end
  end

end
