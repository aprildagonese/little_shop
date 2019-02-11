require "rails_helper"

describe "welcome page" do
  it "user sees welcome page" do
    image = "https://s3.amazonaws.com/medias.photodeck.com/87f72f35-b4d1-4027-b437-7e97f1168fe7/hand-holding-food-plate_9113_wqxga.jpg"
    visit welcome_path

    expect(page).to have_content("Welcome")
    expect(page).to have_link("Enter")
    expect(page).to have_css("img[src*='#{image}']")
  end

  it "can enter site" do
    visit welcome_path

    click_on "Enter"

    expect(current_path).to eq(items_path)
  end
end
