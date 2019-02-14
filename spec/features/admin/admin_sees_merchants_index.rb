require 'rails_helper'

RSpec.describe "As an admin" do
  it "I can see all merchants' data on the index page" do
    admin_user = User.create!(name: "Admina", email: "admin@email.com", password: "admintest", role: 2)
    merch_1 = User.create!(name: "Merch1", email: "merch1@email.com", password: "merchtest", role: 1)
    merch_2 = User.create!(name: "Merch2", email: "merch2@email.com", password: "merchtest", role: 1)
    merch_3 = User.create!(name: "Merch3", email: "merch3@email.com", password: "merchtest", role: 1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)
    visit admin_merchants_path

    within ".page-name" do
      expect(page).to have_content("All Vendors")
    end
    within ".Merch1-row" do
      expect(page).to have_content("#{merch_1.name}")
      expect(page).to have_content("#{merch_1.city}")
      expect(page).to have_content("#{merch_1.state}")
      expect(page).to have_content("#{merch_1.created_at.to_date.to_s}")
      expect(page).to have_button("Deactivate")
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

  it "toggles merchant activation_status" do
    admin_user = User.create!(name: "Admina", email: "admin@email.com", password: "admintest", role: 2)
    merch_1 = User.create!(name: "Merch1", email: "merch1@email.com", password: "merchtest", role: 1, activation_status: 0)
    merch_2 = User.create!(name: "Merch2", email: "merch2@email.com", password: "merchtest", role: 1, activation_status: 0)
    merch_3 = User.create!(name: "Merch3", email: "merch3@email.com", password: "merchtest", role: 1, activation_status: 1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)
    visit admin_merchants_path

    within ".Merch1-row" do
      expect(page).to have_button("Deactivate")
    end
    within ".Merch2-row" do
      expect(page).to have_button("Deactivate")
    end
    within ".Merch3-row" do
      expect(page).to have_button("Activate")
    end
end
