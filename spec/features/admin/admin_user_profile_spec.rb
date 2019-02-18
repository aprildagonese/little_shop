require 'rails_helper'

RSpec.describe 'as an admin', type: :feature do

  before :each do
    @user = create(:user)
    @merchant = create(:user, role: 1)
    @admin = create(:user, role: 2)
    @order = create(:order, user: @user)
    @i1, @i2, @i3, @i4, @i5 = create_list(:item, 5, user: @merchant)
    @oi1, @oi2, @oi3, @oi4, @oi5 = create_list(:order_item, 5)
    @oi1.update(order: @order, item: @i1, sale_price: 2, quantity: 5)
    @oi2.update(order: @order, item: @i2, sale_price: 3, quantity: 5)
    @oi3.update(order: @order, item: @i3, sale_price: 4, quantity: 5)
    @oi4.update(order: @order, item: @i4, sale_price: 5, quantity: 5)
    @oi5.update(order: @order, item: @i5, sale_price: 6, quantity: 5)
    @order_items = [@oi1, @oi2, @oi3, @oi4, @oi5]

    login_as(@admin)
  end

  it 'can see a users profile with account info' do

    visit admin_user_path(@user)

    within ".profile" do
      expect(page).to have_content("Name: #{@user.name}")
      expect(page).to have_content("Address: #{@user.street_address}")
      expect(page).to have_content("City: #{@user.city}")
      expect(page).to have_content("State: #{@user.state}")
      expect(page).to have_content("Zip Code: #{@user.zip_code}")
      expect(page).to have_content("Email: #{@user.email}")
    end

    expect(page).to have_button("Edit Profile")
    expect(page).to have_button("User Orders")
  end

  it "clicking 'edit profile' brings admin to edit profile form" do

    visit admin_user_path(@user)

    click_button 'Edit Profile'

    expect(current_path).to eq(edit_admin_user_path(@user))
    expect(page).to have_content("Edit Profile")
  end

  it "clicking 'user orders' brings admin to user orders index" do

    visit admin_user_path(@user)

    click_button 'User Orders'

    expect(current_path).to eq(admin_orders_path)
  end

end
