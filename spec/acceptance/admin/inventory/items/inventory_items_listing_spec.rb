require 'acceptance_spec_helper'

feature "Inventory Item Listing", js: true, search: true do
  before do
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
    login_into_admin
  end

  context "existent inventory_item" do
    before do
      visit admin_inventory_items_path
    end

    scenario "As a store admin, I want to see items from my company only" do
      page.should have_content "My item"
      page.should_not have_content "Other item"
    end
  end
end
