require "rails_helper"

RSpec.describe Item, type: :model do
  describe "relationships" do
    it {should have_many :order_items}
    it {should have_many(:orders).through :order_items}
    it {should belong_to :user}
  end

  describe 'Validations' do
    describe 'Required Field(s)' do
      it {should validate_presence_of(:title)}
    end
  end

  describe 'Class Methods' do
  end

  describe "Instance Methods" do
  end

end
