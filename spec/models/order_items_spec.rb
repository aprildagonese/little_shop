require "rails_helper"

RSpec.describe OrderItem, type: :model do
  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
  end

  describe 'Validations' do
    # it {should validate_presence_of(:quantity)}
    it {should validate_presence_of(:sale_price)}
  end

  describe 'Class Methods' do
  end

  describe "Instance Methods" do
  end

end
