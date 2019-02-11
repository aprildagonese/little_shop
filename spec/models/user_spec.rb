require "rails_helper"

RSpec.describe User, type: :model do
  describe "relationships" do
    it {should have_many :items}
    it {should have_many :orders}
  end

  describe 'Validations' do
    describe 'Required Field(s)' do
      it 'should be invalid if missing a ' do
      end
    end
  end

  # describe 'Roles' do
  #   it "can be created as an admin" do
  #     user = User.create(username: "april",
  #                        password: "test",
  #                        role: 3)
  #
  #     expect(user.role).to eq("admin")
  #     expect(user.admin?).to be_truthy
  #   end
  #
  #   it "can be created as a merchant" do
  #     user = User.create(username: "peregrine",
  #                        password: "test",
  #                        role: 2)
  #
  #     expect(user.role).to eq("merchant")
  #     expect(user.merchant?).to be_truthy
  #   end
  #
  #   it "can be created as a registered user" do
  #     user = User.create(username: "scott",
  #                        password: "test",
  #                        role: 1)
  #
  #     expect(user.role).to eq("registered")
  #     expect(user.registered?).to be_truthy
  #   end
  #
  #   it "can be created as a default user" do
  #     user = User.create(username: "zach",
  #                        password: "test",
  #                        role: 0)
  #
  #     expect(user.role).to eq("default")
  #     expect(user.default?).to be_truthy
  #   end
  # end


  describe 'Class Methods' do
  end

  describe "Instance Methods" do
  end

end
