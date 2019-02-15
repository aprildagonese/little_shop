require 'rails_helper'

RSpec.describe 'when it visits an items show page' do
  context 'As a visitor' do
    it 'can see all enabled items' do
      merchant = create(:user, role: 1)
      item = create(:item, user: merchant)

      visit item_path(item)

      expect(current_path).to eq(item_path(item))
      expect(page).to have_content(item.title)
      expect(page).to have_content(item.description)
      expect(page).to have_css("img[src*='#{item.image_url}']")
      expect(page).to have_content("Sold By: #{item.user.name}")
      expect(page).to have_content("Qty In Stock: #{item.quantity}")
      expect(page).to have_content("Current Price: $#{item.price}")
      expect(page).to have_content("Average fulfillemnt time: #{item.fulfillment_time}")
    end

    it 'can see a link to add item to cart' do
      merchant = create(:user, role: 1)
      item = create(:item, user: merchant)

      visit item_path(item)

      expect(page).to have_link("Add Item To Cart")
    end
  end

  context 'As a user' do

    it 'can see all enabled items' do
      user = create(:user)
      login_as(user)

      merchant = create(:user, role: 1)
      item = create(:item, user: merchant)

      visit item_path(item)

      expect(current_path).to eq(item_path(item))
      expect(page).to have_content(item.title)
      expect(page).to have_content(item.description)
      expect(page).to have_css("img[src*='#{item.image_url}']")
      expect(page).to have_content("Sold By: #{item.user.name}")
      expect(page).to have_content("Qty In Stock: #{item.quantity}")
      expect(page).to have_content("Current Price: $#{item.price}")
      expect(page).to have_content("Average fulfillemnt time: #{item.fulfillment_time}")
    end

    it 'can see a link to add item to cart' do
      user = create(:user)
      login_as(user)

      merchant = create(:user, role: 1)
      item = create(:item, user: merchant)

      visit item_path(item)

      expect(page).to have_link("Add Item To Cart")
    end
  end

  context 'As a merchant' do

    it 'can see all enabled items' do
      user = create(:user, role: 1)
      login_as(user)

      merchant = create(:user, role: 1)
      item = create(:item, user: merchant)

      visit item_path(item)

      expect(current_path).to eq(item_path(item))
      expect(page).to have_content(item.title)
      expect(page).to have_content(item.description)
      expect(page).to have_css("img[src*='#{item.image_url}']")
      expect(page).to have_content("Sold By: #{item.user.name}")
      expect(page).to have_content("Qty In Stock: #{item.quantity}")
      expect(page).to have_content("Current Price: $#{item.price}")
      expect(page).to have_content("Average fulfillemnt time: #{item.fulfillment_time}")
    end

    it 'cant see a link to add item to cart' do
      user = create(:user, role: 1)
      login_as(user)

      binding.pry
      merchant = create(:user, role: 1)
      item = create(:item, user: merchant)

      visit item_path(item)

      expect(page).to_not have_link("Add Item To Cart")
    end
  end

  context 'As an admin' do

    it 'can see all enabled items' do
      user = create(:user, role: 2)
      login_as(user)

      merchant = create(:user, role: 1)
      item = create(:item, user: merchant)

      visit item_path(item)

      expect(current_path).to eq(item_path(item))
      expect(page).to have_content(item.title)
      expect(page).to have_content(item.description)
      expect(page).to have_css("img[src*='#{item.image_url}']")
      expect(page).to have_content("Sold By: #{item.user.name}")
      expect(page).to have_content("Qty In Stock: #{item.quantity}")
      expect(page).to have_content("Current Price: $#{item.price}")
      expect(page).to have_content("Average fulfillemnt time: #{item.fulfillment_time}")
    end

    it 'cant see a link to add item to cart' do
      user = create(:user, role: 2)
      login_as(user)

      merchant = create(:user, role: 1)
      item = create(:item, user: merchant)

      visit item_path(item)

      expect(page).to_not have_link("Add Item To Cart")
    end
  end

end