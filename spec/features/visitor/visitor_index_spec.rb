require 'rails_helper'

RSpec.describe "visitor index page", type: :feature do
  before :each do
    @item_1 = Item.create(name: "item1")
  end
  #
  # describe 'As a visitor' do
  #   xit 'displays all items' do
  #
  # 	visit '/items'
  #
  # 	expect..
  #
  #   end
end
