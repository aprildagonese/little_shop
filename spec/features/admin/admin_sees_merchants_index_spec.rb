require 'rails_helper'

RSpec.describe "As an admin" do
  it "I can see all merchants' data on the index page" do
    admin_user = User.create!(name: "Admina", email: "admin@email.com", password: "admintest", role: 2)
    merch_1 = User.create!(name: "Merch1", city: "TestCity1", state: "TestState1", email: "merch1@email.com", password: "merchtest", role: 1)
    merch_2 = User.create!(name: "Merch2", city: "TestCity2", state: "TestState2", email: "merch2@email.com", password: "merchtest", role: 1)
    merch_3 = User.create!(name: "Merch3", city: "TestCity3", state: "TestState3", email: "merch3@email.com", password: "merchtest", role: 1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)
    visit admin_merchants_path


    expect(page).to have_content("All Merchants")

    within ".user-#{merch_1.id}-row" do
      expect(page).to have_link("#{merch_1.name}", href: admin_merchant_path(merch_1))
      expect(page).to have_content("#{merch_1.city}")
      expect(page).to have_content("#{merch_1.state}")
      expect(page).to have_content("#{merch_1.created_at.to_date.to_s}")
      expect(page).to have_button("Disable")
      expect(page).to_not have_content("#{merch_2.name}")
      expect(page).to_not have_content("#{merch_2.city}")
      expect(page).to_not have_content("#{merch_3.name}")
      expect(page).to_not have_content("#{merch_3.city}")
    end
    within ".user-#{merch_2.id}-row" do
      expect(page).to have_link("#{merch_2.name}", href: admin_merchant_path(merch_2))
      expect(page).to have_content("#{merch_2.city}")
      expect(page).to have_content("#{merch_2.state}")
      expect(page).to have_content("#{merch_2.created_at.to_date.to_s}")
      expect(page).to_not have_content("#{merch_1.name}")
      expect(page).to_not have_content("#{merch_1.city}")
      expect(page).to_not have_content("#{merch_3.name}")
      expect(page).to_not have_content("#{merch_3.city}")
    end
    within ".user-#{merch_3.id}-row" do
      expect(page).to have_link("#{merch_3.name}", href: admin_merchant_path(merch_3))
      expect(page).to have_content("#{merch_3.city}")
      expect(page).to have_content("#{merch_3.state}")
      expect(page).to have_content("#{merch_3.created_at.to_date.to_s}")
      expect(page).to_not have_content("#{merch_2.name}")
      expect(page).to_not have_content("#{merch_2.city}")
      expect(page).to_not have_content("#{merch_1.name}")
      expect(page).to_not have_content("#{merch_1.city}")
    end
  end

  it "I can toggle merchant activation_status" do
    admin_user = User.create!(name: "Admina", email: "admin@email.com", password: "admintest", role: 2)
    merch_1 = User.create!(name: "Merch1", email: "merch1@email.com", password: "merchtest", role: 1, activation_status: 0)
    merch_2 = User.create!(name: "Merch2", email: "merch2@email.com", password: "merchtest", role: 1, activation_status: 0)
    merch_3 = User.create!(name: "Merch3", email: "merch3@email.com", password: "merchtest", role: 1, activation_status: 1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)
    visit admin_merchants_path

    within ".user-#{merch_1.id}-row" do
      expect(page).to have_button("Disable")
    end
    within ".user-#{merch_2.id}-row" do
      expect(page).to have_button("Disable")
    end
    within ".user-#{merch_3.id}-row" do
      expect(page).to have_button("Enable")
    end

    within ".user-#{merch_1.id}-row" do
      click_button("Disable")
    end
    within ".user-#{merch_2.id}-row" do
      click_button("Disable")
    end
    within ".user-#{merch_3.id}-row" do
      click_button("Enable")
    end

    within ".user-#{merch_1.id}-row" do
      expect(page).to have_button("Enable")
    end
    within ".user-#{merch_2.id}-row" do
      expect(page).to have_button("Enable")
    end
    within ".user-#{merch_3.id}-row" do
      expect(page).to have_button("Disable")
    end
  end
end
