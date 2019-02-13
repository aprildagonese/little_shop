require 'rails_helper'

RSpec.describe "as a visitor" do
  context "visiting merchants_path" do

    before :each do
      @april = User.create!(name: "April", email: "adag@email.com", password: "password", role: 0)
      @merch_1 = User.create!(name: "Merch1", city: "Denver", state: "CO", email: "merch1@email.com", password: "merchtest", role: 1)
      @merch_2 = User.create!(name: "Merch2", city: "Los Angeles", state: "CA", email: "merch2@email.com", password: "merchtest", role: 1)
      @merch_3 = User.create!(name: "Merch3", city: "Seattle", state: "WA", email: "merch3@email.com", password: "merchtest", role: 1)
      @merch_4 = User.create!(name: "Merch4", city: "Austin", state: "TX", email: "merch4@email.com", password: "merchtest", role: 1)
      @merch_5 = User.create!(name: "Merch5", city: "Portland", state: "OR", email: "merch5@email.com", password: "merchtest", role: 1)
      @merch_6 = User.create!(name: "Merch6", city: "New York City", state: "NY", email: "merch6@email.com", password: "merchtest", role: 1)

    end

    it "it shows a list of all merchants" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@april)
      visit merchants_path

      expect(page).to have_content("All Restaurants")
      within ".Merch1-row" do
        expect(page).to have_content("#{@merch_1.name}")
        expect(page).to have_content("#{@merch_1.city}")
        expect(page).to have_content("#{@merch_1.state}")
        expect(page).to have_content("#{@merch_1.created_at.to_date.to_s}")
        expect(page).to_not have_content("#{@merch_2.name}")
        expect(page).to_not have_content("#{@merch_2.city}")
        expect(page).to_not have_content("#{@merch_3.name}")
        expect(page).to_not have_content("#{@merch_3.city}")
      end
      within ".Merch2-row" do
        expect(page).to have_content("#{@merch_2.name}")
        expect(page).to have_content("#{@merch_2.city}")
        expect(page).to have_content("#{@merch_2.state}")
        expect(page).to have_content("#{@merch_2.created_at.to_date.to_s}")
        expect(page).to_not have_content("#{@merch_1.name}")
        expect(page).to_not have_content("#{@merch_1.city}")
        expect(page).to_not have_content("#{@merch_3.name}")
        expect(page).to_not have_content("#{@merch_3.city}")
      end
      within ".Merch3-row" do
        expect(page).to have_content("#{@merch_3.name}")
        expect(page).to have_content("#{@merch_3.city}")
        expect(page).to have_content("#{@merch_3.state}")
        expect(page).to have_content("#{@merch_3.created_at.to_date.to_s}")
        expect(page).to_not have_content("#{@merch_2.name}")
        expect(page).to_not have_content("#{@merch_2.city}")
        expect(page).to_not have_content("#{@merch_1.name}")
        expect(page).to_not have_content("#{@merch_1.city}")
      end
    end
    it "shows merchant statistics" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@april)
      visit merchants_path
    end

  end
end
