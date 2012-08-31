require 'acceptance_spec_helper'

feature "Managing the store", js: true, search: true do
  before do
    @admin_user = FactoryGirl.create(:admin_user)
    FactoryGirl.create(:good_with_company)
    @good = FactoryGirl.create(:good, user: @admin_user, company: @admin_user.company)

    login_into_admin
  end

  context "existent goods" do
    scenario "As a store admin, I'd like to add items to the inventory" do
      visit admin_store_dashboard_path

      fill_in "search_goods", with: @good.name
      wait_until { page.has_content?(@good.name) }

      click_link @good.name

      current_path.should == admin_inventory_good_path(@good)
      page.should have_content @good.name
    end
  end
end
