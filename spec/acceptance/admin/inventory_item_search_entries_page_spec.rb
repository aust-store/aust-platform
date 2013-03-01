require 'acceptance_spec_helper'

feature "Adding Inventory Entries" do
  before do
    login_into_admin
    FactoryGirl.create(:inventory_item, company: @company)
    @item = FactoryGirl.create(:inventory_item,
                               user: @admin_user,
                               company: @company)
  end

  context "existent inventory items" do
    scenario "As a store admin, I'd like to create inventory entries" do
      visit admin_inventory_item_path(@item)

      click_link "add_item_entry"

      fill_in "inventory_entry_quantity", with: "4"
      fill_in "inventory_entry_cost_per_unit", with: "11"

      click_button "submit_entry"
      page.should have_content "R$ 11,00"

      # pre-existing entry
      page.should have_content "R$ 20,00"
    end
  end
end
