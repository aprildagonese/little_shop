require "rails_helper"

describe "welcome page" do
  it "user sees welcome page" do
    image = "https://c7.alamy.com/comp/HP4NBT/cartoon-chef-or-baker-holding-a-silver-cloche-food-meal-plate-platter-HP4NBT.jpg"
    visit root_path

    expect(page).to have_content("Welcome")
    expect(page).to have_link("Enter")
    expect(page).to have_css("img[src*='#{image}']")
  end
end
