require 'acceptance_spec_helper'

feature "Inventory Item Listing", js: true, search: true do
  before do
    @other_user = FactoryGirl.create(:admin_user)
    @other_company = @other_user.company
    @other_good = FactoryGirl.create(:good, name: "Other good", user: @other_user, company: @other_company)

    @admin_user = FactoryGirl.create(:admin_user)
    @good = FactoryGirl.create(:good, name: "My good", user: @admin_user, company: @admin_user.company)
    login_into_admin
  end

  context "existent goods" do
    before do
      visit admin_inventory_goods_path
    end

    scenario "As a store admin, I want to see goods from my company only" do
      page.should have_content "My good"
      page.should_not have_content "Other good"
    end
  end
end
