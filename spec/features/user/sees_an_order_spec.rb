require 'rails_helper'

RSpec.describe "as a registered user" do
  before :each do
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
      within ".#{@oi1.title}-row" do
        expect(page).to have_content("#{@oi1.image_url}")
        expect(page).to have_content("#{@oi1.title}")
        expect(page).to have_content("#{@oi1.sale_price}")
        expect(page).to have_content("#{@oi1.quantity}")
        expect(page).to have_content("#{@oi1.description}")
        expect(page).to have_content("#{@oi1.description}")
        expect(page).to have_content("Subtotal Placeholder")
      end
    end
  end
end
