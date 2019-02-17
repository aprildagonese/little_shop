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
  end

end
