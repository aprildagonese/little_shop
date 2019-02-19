require "rails_helper"

RSpec.describe User, type: :model do
  describe "relationships" do
    it {should have_many :items}
  end

  describe 'Validations' do
    describe 'Required Field(s)' do
      it {should validate_presence_of(:name)}
      it {should validate_uniqueness_of(:name)}
      it {should validate_presence_of(:email)}
      it {should validate_uniqueness_of(:email)}
      it {should validate_presence_of(:password)}
    end
  end

  describe 'Roles' do
    it "can be created as an admin" do
      user = User.create(name: "april",
                         password: "test",
                         role: 2)

      expect(user.role).to eq("admin")
      expect(user.admin?).to be_truthy
      expect(user.merchant?).to eq(false)
      expect(user.registered?).to eq(false)
    end

    it "can be created as a merchant" do
      user = User.create(name: "peregrine",
                         password: "test",
                         role: 1)

      expect(user.role).to eq("merchant")
      expect(user.merchant?).to be_truthy
      expect(user.admin?).to eq(false)
      expect(user.registered?).to eq(false)
    end

    it "can be created as a registered user" do
      user = User.create(name: "scott",
                         password: "test",
                         role: 0)

      expect(user.role).to eq("registered")
      expect(user.registered?).to be_truthy
      expect(user.merchant?).to eq(false)
      expect(user.admin?).to eq(false)
    end
  end


  describe 'Class Methods' do
  end

  describe "Instance Methods" do
    before :each do
      Faker::UniqueGenerator.clear
    end

    it "#change_status" do
      user = User.create!(name: "April",
                          email: "adag@email.com",
                          password: "password",
                          activation_status: 0)
      user.change_status
      expect(user.activation_status).to eq("inactive")
      user.change_status
      expect(user.activation_status).to eq("active")
    end

    it '#downgrade' do
      merchant = create(:user, role: 1)
      item_1 = create(:item, active: true)
      item_2 = create(:item, active: true)
      item_3 = create(:item, active: true)
      merchant.items << item_1
      merchant.items << item_2
      merchant.items << item_3

      expect(merchant.role).to eq("merchant")
      expect(item_1.active).to eq(true)
      expect(item_2.active).to eq(true)
      expect(item_3.active).to eq(true)
      merchant.downgrade
      expect(merchant.role).to eq("registered")
      expect(item_1.active).to eq(false)
      expect(item_2.active).to eq(false)
      expect(item_3.active).to eq(false)
    end

    context 'merchant dash stats' do
      before :each do
        @merch1, @merch2 = create_list(:user, 2, role: 1)
        @user1 = create(:user, city: "Springfield", state: "IL")
        @user2 = create(:user, city: "Springfield", state: "MO")
        @user3 = create(:user, city: "Chicago", state: "IL")
        @item1, @item2 = create_list(:item, 2, user: @merch1)
        @item3 = create(:item, user: @merch2)
        @order1, @order2 = create_list(:order, 2, user: @user1)
        @order3, @order4 = create_list(:order, 2, user: @user2)
        @order5 = create(:order, user: @user3)
        @oi1 = create(:fulfilled_order_item, order: @order1, item: @item1, quantity: 1)
        @oi2 = create(:order_item, order: @order1, item: @item2, quantity: 2)
        @oi3 = create(:order_item, order: @order1, item: @item3, quantity: 3)
        @oi4 = create(:fulfilled_order_item, order: @order2, item: @item1, quantity: 4)
        @oi5 = create(:order_item, order: @order2, item: @item2, quantity: 5)
        @oi6 = create(:order_item, order: @order2, item: @item3, quantity: 6)
        @oi7 = create(:fulfilled_order_item, order: @order3, item: @item1, quantity: 7)
        @oi8 = create(:order_item, order: @order3, item: @item2, quantity: 8)
        @oi9 = create(:order_item, order: @order3, item: @item3, quantity: 9)
        @oi10 = create(:fulfilled_order_item, order: @order4, item: @item1, quantity: 10)
        @oi11 = create(:order_item, order: @order4, item: @item2, quantity: 11)
        @oi12 = create(:order_item, order: @order4, item: @item3, quantity: 12)
        @oi13 = create(:fulfilled_order_item, order: @order5, item: @item1, quantity: 13)
        @oi14 = create(:order_item, order: @order5, item: @item2, quantity: 14)
        @oi15 = create(:order_item, order: @order5, item: @item3, quantity: 15)
      end

      it "#total_sold_quantity should get merchant's sum of all quantities sold for all items" do
        merch1, merch2 = create_list(:user, 2, role: 1)
        user1, user2, user3 = create_list(:user, 3)
        item1, item2 = create_list(:item, 2, user: merch1)
        item3 = create(:item, user: merch2)
        order1, order2 = create_list(:order, 2, user: user1)
        order3, order4 = create_list(:order, 2, user: user2)
        order5 = create(:order, user: user3)
        oi1 = create(:order_item, order: order1, item: item1, quantity: 1)
        oi2 = create(:order_item, order: order1, item: item2, quantity: 2)
        oi3 = create(:order_item, order: order1, item: item3, quantity: 3)
        oi4 = create(:order_item, order: order2, item: item1, quantity: 4)
        oi5 = create(:order_item, order: order2, item: item2, quantity: 5)
        oi6 = create(:order_item, order: order2, item: item3, quantity: 6)
        oi7 = create(:order_item, order: order3, item: item1, quantity: 7)
        oi8 = create(:order_item, order: order3, item: item2, quantity: 8)
        oi9 = create(:order_item, order: order3, item: item3, quantity: 9)
        oi10 = create(:order_item, order: order4, item: item1, quantity: 10)
        oi11 = create(:order_item, order: order4, item: item2, quantity: 11)
        oi12 = create(:order_item, order: order4, item: item3, quantity: 12)
        oi13 = create(:order_item, order: order5, item: item1, quantity: 13)
        oi14 = create(:order_item, order: order5, item: item2, quantity: 14)
        oi15 = create(:order_item, order: order5, item: item3, quantity: 15)

        expected1 = (oi1.quantity + oi2.quantity + oi4.quantity + oi5.quantity + oi7.quantity + oi8.quantity + oi10.quantity + oi11.quantity + oi13.quantity + oi14.quantity)
        expected2 = (oi3.quantity + oi6.quantity + oi9.quantity + oi12.quantity + oi15.quantity)

        expect(Item.total_sold_quantity(merch1)).to eq(expected1)
        expect(Item.total_sold_quantity(merch2)).to eq(expected2)

      end

      it '#top_states shows the top 3 states for that user and their quantities' do
        expected = @merch1.top_states(3)

        expect(expected[1].state).to eq(@user2.state)
        expect(expected[1].total_items).to eq(17)

        expect(expected[0].state).to eq(@user1.state)
        expect(expected[0].total_items).to eq(18)

      end
    end
  end
end


#- top 3 city/state where my items were shipped, and their quantities (Springfield, MI should not be grouped with Springfield, CO)
#- top 3 users who have spent the most money on my items, and the total amount they've spent
