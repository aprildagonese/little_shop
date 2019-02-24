require "rails_helper"

describe "welcome page" do
  it "user sees welcome page" do
    visit welcome_path

    expect(page).to have_content("Welcome")
    expect(page).to have_link("Enter")
  end

  it "can enter site" do
    visit welcome_path

    click_on "Enter"

    expect(current_path).to eq(items_path)
  end
end
