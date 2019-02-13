require 'rails_helper'

RSpec.describe "as a visitor" do
  context "visiting merchants_path" do
    it "it shows a list of all merchants" do
      april = User.create!(name: "April", email: "adag@email.com", password: "password", role: 0)
      merch_1 = User.create!(name: "Merch1", city: "Denver", state: "CO", email: "merch1@email.com", password: "merchtest", role: 1)
      merch_2 = User.create!(name: "Merch2", city: "Los Angeles", state: "CA", email: "merch2@email.com", password: "merchtest", role: 1)
      merch_3 = User.create!(name: "Merch3", city: "Seattle", state: "WA", email: "merch3@email.com", password: "merchtest", role: 1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(april)
      visit merchants_path

      expect(page).to have_content("All Restaurants")
      within ".Merch1-row" do
        expect(page).to have_content("#{merch_1.name}")
        expect(page).to have_content("#{merch_1.city}")
        expect(page).to have_content("#{merch_1.state}")
        expect(page).to have_content("#{merch_1.created_at.to_date.to_s}")
        expect(page).to_not have_content("#{merch_2.name}")
        expect(page).to_not have_content("#{merch_2.city}")
        expect(page).to_not have_content("#{merch_3.name}")
        expect(page).to_not have_content("#{merch_3.city}")
      end
      within ".Merch2-row" do
        expect(page).to have_content("#{merch_2.name}")
        expect(page).to have_content("#{merch_2.city}")
        expect(page).to have_content("#{merch_2.state}")
        expect(page).to have_content("#{merch_2.created_at.to_date.to_s}")
        expect(page).to_not have_content("#{merch_1.name}")
        expect(page).to_not have_content("#{merch_1.city}")
        expect(page).to_not have_content("#{merch_3.name}")
        expect(page).to_not have_content("#{merch_3.city}")
      end
      within ".Merch3-row" do
        expect(page).to have_content("#{merch_3.name}")
        expect(page).to have_content("#{merch_3.city}")
        expect(page).to have_content("#{merch_3.state}")
        expect(page).to have_content("#{merch_3.created_at.to_date.to_s}")
        expect(page).to_not have_content("#{merch_2.name}")
        expect(page).to_not have_content("#{merch_2.city}")
        expect(page).to_not have_content("#{merch_1.name}")
        expect(page).to_not have_content("#{merch_1.city}")
      end
    end
  end
end
