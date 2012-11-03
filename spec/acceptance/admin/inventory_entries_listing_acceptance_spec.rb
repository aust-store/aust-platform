require 'acceptance_spec_helper'

feature "Listing inventory entries", js: true, search: true do
  background do
    @other_user = FactoryGirl.create(:admin_user)
    @other_company = @other_user.company
    @other_good = FactoryGirl.create(:good, name: "Other good", user: @other_user, company: @other_company)

    @admin_user = FactoryGirl.create(:admin_user)
    @good = FactoryGirl.create(:good, name: "My good", user: @admin_user, company: @admin_user.company)
    10.times { |t| FactoryGirl.create(:inventory_entry, description: "Entry #{t+1}", quantity: (t+1), good: @good, admin_user: @admin_user) }

    login_into_admin
  end

  describe "list of a good's current inventory entries" do
    before do
      visit admin_inventory_good_entries_path(@good)
    end

    scenario "As a store admin, I want to see goods from my company only" do
      page.should have_content "Entry 1"
      page.should have_content "4"
      page.should have_content "R$ 20,00"

      page.should have_content "Entry 2"
      page.should have_content "Entry 3"
      page.should have_content "Entry 4"
      page.should have_content "Entry 5"
      page.should have_content "Entry 6"
      page.should have_content "Entry 7"
      page.should have_content "Entry 8"
      page.should have_content "Entry 9"
      page.should have_content "Entry 10"
      page.should_not have_content "Other good"
    end
  end
end

