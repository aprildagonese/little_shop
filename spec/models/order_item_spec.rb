require "rails_helper"

RSpec.describe OrderItem, type: :model do
  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
  end

  describe 'Validations' do
  end

  describe 'Class Methods' do
  end

  describe "Instance Methods" do
  end

end
