require "rails_helper"

RSpec.describe Item, type: :model do
  # describe "relationships" do
  #   it {should have_many :}
  #   it {should have_many(:).through(:)}
  #   it {should belong_to(:)}
  # end

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
