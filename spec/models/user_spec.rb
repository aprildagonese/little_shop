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
    it ".user_by_most_orders" do
      Faker::UniqueGenerator.clear
      merchant1, merchant2, merchant3 = create_list(:user, 3, role: 1)
      user1, user2, user3 = create_list(:user, 3, role: 0)
      item1, item2, item3 = create_list(:item, 3, user: merchant1)
      item4, item5 = create_list(:item, 2, user: merchant2)
      item6, item7 = create_list(:item, 2, user: merchant3)

      order1 = create(:order, user: user1) #user1 orders from merch1
      oi1 = create(:order_item, order: order1, item: item1, status: 1)

      order2 = create(:order, user: user2) #user2 orders from both
      oi2 = create(:order_item, order: order2, item: item3, status: 1)
      oi3 = create(:order_item, order: order2, item: item5, status: 1)

      order3 = create(:order, user: user2) #user2 orders from both
      oi4 = create(:order_item, order: order3, item: item2)
      oi5 = create(:order_item, order: order3, item: item4, status: 1)

      order4 = create(:order, user: user1) #user1 orders from merch1
      oi5 = create(:order_item, order: order4, item: item1)
      oi6 = create(:order_item, order: order4, item: item2)

      order5 = create(:order, user: user2) #user2 orders from merch2
      oi7 = create(:order_item, order: order5, item: item4)
      oi8 = create(:order_item, order: order5, item: item5, status: 1)

      order6 = create(:order, user: user2) #user1 orders from merch1
      oi7 = create(:order_item, order: order6, item: item1)
      oi8 = create(:order_item, order: order6, item: item2, status: 1)

      order7 = create(:order, user: user3)
      oi9 = create(:order_item, order: order7, item: item6, status: 1)
      oi10 = create(:order_item, order: order7, item: item7, status: 0)

      expect(User.user_by_most_orders(merchant1)).to eq(user1)
      expect(User.user_by_most_orders(merchant2)).to eq(user2)
      expect(User.user_by_most_orders(merchant3)).to eq(user3)
    end
  end

  describe "Instance Methods" do
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
  end
end
