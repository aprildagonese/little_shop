require 'rails_helper'

RSpec.describe "as a registered user" do
  before :each do
    Faker::UniqueGenerator.clear
    
    @user = create(:user)
    @order = create(:order, user: @user)
    @i1, @i2, @i3, @i4, @i5 = create_list(:item, 5)
    @oi1, @oi2, @oi3, @oi4, @oi5 = create_list(:order_item, 5)
    @oi1.update(order: @order, item: @i1)
    @oi2.update(order: @order, item: @i2)
    @oi3.update(order: @order, item: @i3)
    @oi4.update(order: @order, item: @i4)
    @oi5.update(order: @order, item: @i5)
  end

  context "when I visit an order show page" do
    it "I see all items on my order" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit user_order_path(@user, @order)

      within ".id-#{@oi1.id}-row" do
        expect(page).to have_content("#{@oi1.item.image_url}")
        expect(page).to have_content("#{@oi1.item.title}")
        expect(page).to have_content("#{@oi1.sale_price}")
        expect(page).to have_content("#{@oi1.quantity}")
        expect(page).to have_content("#{@oi1.item.description}")
        expect(page).to have_content("#{@oi1.subtotal}")
      end
      within ".id-#{@oi2.id}-row" do
        expect(page).to have_content("#{@oi2.item.image_url}")
        expect(page).to have_content("#{@oi2.item.title}")
        expect(page).to have_content("#{@oi2.sale_price}")
        expect(page).to have_content("#{@oi2.quantity}")
        expect(page).to have_content("#{@oi2.item.description}")
        expect(page).to have_content("#{@oi2.subtotal}")
      end
      within ".id-#{@oi3.id}-row" do
        expect(page).to have_content("#{@oi3.item.image_url}")
        expect(page).to have_content("#{@oi3.item.title}")
        expect(page).to have_content("#{@oi3.sale_price}")
        expect(page).to have_content("#{@oi3.quantity}")
        expect(page).to have_content("#{@oi3.item.description}")
        expect(page).to have_content("#{@oi3.subtotal}")
      end
      within ".id-#{@oi4.id}-row" do
        expect(page).to have_content("#{@oi4.item.image_url}")
        expect(page).to have_content("#{@oi4.item.title}")
        expect(page).to have_content("#{@oi4.sale_price}")
        expect(page).to have_content("#{@oi4.quantity}")
        expect(page).to have_content("#{@oi4.item.description}")
        expect(page).to have_content("#{@oi4.subtotal}")
      end
      within ".id-#{@oi5.id}-row" do
        expect(page).to have_content("#{@oi5.item.image_url}")
        expect(page).to have_content("#{@oi5.item.title}")
        expect(page).to have_content("#{@oi5.sale_price}")
        expect(page).to have_content("#{@oi5.quantity}")
        expect(page).to have_content("#{@oi5.item.description}")
        expect(page).to have_content("#{@oi5.subtotal}")
      end
    end
  end
end
