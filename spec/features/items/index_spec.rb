require 'rails_helper'

RSpec.describe 'As any user' do
  Faker::UniqueGenerator.clear

  context 'when it visits the index page' do

    it 'can see all enabled items' do
      Faker::UniqueGenerator.clear
      user = create(:user)
      user.update(role: 1)
      i1, i2, i3, i4, i5 = create_list(:item, 5, user: user)
      i4.update(active: false)
      i5.update(active: false)

      active_items = [i1, i2, i3]
      inactive_items = [i4, i5]

      visit items_path

      active_items.each do |item|
        expect(page).to have_content(item.title)
        expect(page).to have_css("img[src*='#{item.image_url}']")
        expect(page).to have_content("Sold By: #{item.user.name}")
        expect(page).to have_content("Qty: #{item.quantity}")
        expect(page).to have_content("Current Price: $#{item.price}")
      end

      inactive_items.each do |item|
        expect(page).to_not have_content(item.title)
      end
    end

    it 'items name is a link' do

      Faker::UniqueGenerator.clear

      user = create(:user)
      user.update(role: 1)
      i1, i2 = create_list(:item, 2, user: user)

      visit items_path

      click_link "#{i1.title}"

      expect(current_path).to eq(item_path(i1))
      expect(page).to have_content(i1.title)
      expect(page).to_not have_content(i2.title)
    end

  context 'it can see item statistics'
    it 'can see top 5 most popular items with quantity' do
      user_1 = create(:user, role: 1)
      user_2 = create(:user, role: 1)
      i1, i2, i3, i4 = create_list(:item, 4, user: user_1)
      i5, i6, i7, i8 = create_list(:item, 4, user: user_2)
      order_1 = create(:order, status: 1)
      order_2 = create(:order, status: 1)
      order_3 = create(:order, status: 0)

      create(:order_item, item: i1, order: order_1, quantity: 8, sale_price: 5)
      create(:order_item, item: i2, order: order_2, quantity: 7, sale_price: 5)
      create(:order_item, item: i3, order: order_1, quantity: 6, sale_price: 5)
      create(:order_item, item: i4, order: order_2, quantity: 5, sale_price: 5)
      create(:order_item, item: i5, order: order_1, quantity: 4, sale_price: 5)
      create(:order_item, item: i6, order: order_2, quantity: 3, sale_price: 5)
      create(:order_item, item: i7, order: order_1, quantity: 2, sale_price: 5)
      create(:order_item, item: i8, order: order_3, quantity: 1, sale_price: 5)
      create(:order_item, item: i4, order: order_1, quantity: 10, sale_price: 5)
      create(:order_item, item: i5, order: order_2, quantity: 10, sale_price: 5)

      visit items_path

      within ".item-statistics" do
        within ".most-popular" do
          expect(page).to have_content("Most popular dishes:")
          expect(page).to have_content("#{i4.title} (15)")
          expect(page).to have_content("#{i5.title} (14)")
          expect(page).to have_content("#{i1.title} (8)")
          expect(page).to have_content("#{i2.title} (7)")
          expect(page).to have_content("#{i3.title} (6)")
          expect(page).to_not have_content(i6.title)
          expect(page).to_not have_content(i7.title)
          expect(page).to_not have_content(i8.title)
        end

        within ".least-popular" do
          expect(page).to have_content("Least popular dishes:")
          expect(page).to have_content("#{i7.title} (2)")
          expect(page).to have_content("#{i6.title} (3)")
          expect(page).to have_content("#{i3.title} (6)")
          expect(page).to have_content("#{i2.title} (7)")
          expect(page).to have_content("#{i1.title} (8)")
          expect(page).to_not have_content(i4.title)
          expect(page).to_not have_content(i5.title)
          expect(page).to_not have_content(i8.title)
        end
      end
    end
  end

end
