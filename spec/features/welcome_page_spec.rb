require "rails_helper"

describe "welcome page" do
  it "user sees welcome page" do
    image = "https://s3.amazonaws.com/medias.photodeck.com/87f72f35-b4d1-4027-b437-7e97f1168fe7/hand-holding-food-plate_9113_wqxga.jpg"
    visit root_path

    expect(page).to have_content("Welcome")
    expect(page).to have_link("Enter")
    expect(page).to have_css("img[src*='#{image}']")
  end
end
