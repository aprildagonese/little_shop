require "rails_helper"

RSpec.describe User, type: :model do
  describe "relationships" do
    it {should have_many :}
    it {should have_many(:).through(:)}
    it {should belong_to(:)}
  end

  describe 'Validations' do
    describe 'Required Field(s)' do
      it 'should be invalid if missing a ' do
      end
    end
  end

  describe 'Class Methods' do
  end

  describe "Instance Methods" do
  end

end
