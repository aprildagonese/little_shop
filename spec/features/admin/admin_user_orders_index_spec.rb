require 'rails_helper'

RSpec.describe 'as an admin', type: :feature do

  before :each do
    Faker::UniqueGenerator.clear

    @user = create(:user)
    @merchant = create(:user, role: 1)
    @admin = create(:user, role: 2)
    @order_1 = create(:order, user: @user)
    @order_2 = create(:order, user: @user)
    @i1, @i2, @i3, @i4, @i5 = create_list(:item, 5, user: @merchant)
    @oi1, @oi2, @oi3, @oi4, @oi5 = create_list(:order_item, 5)
    @oi1.update(order: @order_1, item: @i1, sale_price: 2, quantity: 5)
    @oi2.update(order: @order_1, item: @i2, sale_price: 3, quantity: 5)
    @oi3.update(order: @order_1, item: @i3, sale_price: 4, quantity: 5)
    @oi4.update(order: @order_2, item: @i4, sale_price: 5, quantity: 5)
    @oi5.update(order: @order_2, item: @i5, sale_price: 6, quantity: 5)
    @order_items = [@oi1, @oi2, @oi3, @oi4, @oi5]

    login_as(@admin)
  end

  it "admin can see users order index page" do

    visit admin_user_path(@user.slug)

    click_button 'User Orders'

    expect(current_path).to eq(admin_orders_path)
    expect(page).to have_content("User Orders")
    expect(page).to have_link("Order ID: #{@order_1.id}")
    expect(page).to have_link("Order ID: #{@order_2.id}")
  end

  it "admin can go to users order show page" do

    visit admin_user_path(@user.slug)

    click_button 'User Orders'

    click_link "Order ID: #{@order_1.id}"

    expect(current_path).to eq(admin_order_path(@order_1))
  end

end
