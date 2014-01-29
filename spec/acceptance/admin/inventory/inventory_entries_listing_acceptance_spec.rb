require 'acceptance_spec_helper'

feature "Listing inventory entries", js: true, search: true do
  background do
    @other_user = FactoryGirl.create(:admin_user)
    @other_company = @other_user.company
    @other_item = FactoryGirl.create(:inventory_item,
                                     name: "Other item",
                                     user: @other_user,
                                     company: @other_company)

    @company = FactoryGirl.create(:barebone_company, handle: "mystore")
    @admin_user = FactoryGirl.create(:admin_user, company: @company)
    @item = FactoryGirl.create(:inventory_item,
                               name: "My item",
                               user: @admin_user,
                               company: @admin_user.company)
    10.times do |t|
      FactoryGirl.create(:inventory_entry,
                         description: "Entry #{t+1}",
                         quantity: (t+1),
                         inventory_item: @item,
                         admin_user: @admin_user)
    end

    login_into_admin
  end

  describe "list of a item's current inventory entries" do
    before do
      visit admin_inventory_item_entries_path(@item)
    end

    scenario "As a store admin, I want to see items from my company only" do
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
      page.should_not have_content "Other item"
    end
  end
end
