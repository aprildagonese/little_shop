require 'rails_helper'

RSpec.describe 'as a user', type: :feature do

  before :each do
    Faker::UniqueGenerator.clear

    @user_1 = create(:user)
    @item_1, @item_2, @item_3, @item_4, @item_5, @item_6, @item_7, @item_8, @item_9, @item_10 = create_list(:item, 10)

  end

end
