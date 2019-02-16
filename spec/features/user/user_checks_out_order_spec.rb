require 'rails_helper'

RSpec.describe "as a registered user with items in my cart" do
  before :each do
    @user = create(:user)
    login_as(@user)
    @item1 = create(:item)
    visit item_path(@item1)
    click_button "Add Item To Cart"
    @item2 = create(:item)
    visit item_path(@item2)
    click_button "Add Item To Cart"
    @item3 = create(:item)
    visit item_path(@item3)
    click_button "Add Item To Cart"
  end

  it "I can generate an order" do
    visit cart_path
    expect(Order.count).to eq(0)

    click_button("Check Out")

    expect(Order.count).to eq(1)
    expect(Order.last.status).to eq("pending")
    expect(current_path).to eq(profile_orders_path(@user))
    expect(page).to have_content("Thank you! Your order has been placed.")
    expect(page).to have_content("Cart (0)")
  end
end
