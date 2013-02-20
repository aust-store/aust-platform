require 'acceptance_spec_helper'

feature "Inventory Item creation", js: true do
  before do
    @admin_user = FactoryGirl.create(:admin_user)
    @company = @admin_user.company
    @taxonomy = FactoryGirl.create(:taxonomy, name: "Shirt", store: @company)
    @manufacturer = FactoryGirl.create(:manufacturer, name: "Nike", company: @company)
    login_into_admin
  end

  context "new inventory item" do
    before do
      visit admin_inventory_items_path
      click_link "Adicionar item"
    end

    scenario "As a store admin, I fill in the form and have my item created" do

      # fields used for searching existing items
      fill_in "inventory_item_taxonomy", with: "Shirt"
      fill_in "inventory_item_manufacturer", with: "Nike"
      fill_in "inventory_item_year", with: "2013"
      fill_in "inventory_item_name", with: "Air Max"

      fill_in "inventory_item_description", with: "Item description"
      fill_in "inventory_item_prices_attributes_0_value", with: "R$ 12,34"

      within(".entry") do
        fill_in "inventory_item_entries_attributes_0_quantity", with: "50"
        fill_in "inventory_item_entries_attributes_0_cost_per_unit", with: "R$ 6,12"
      end

      # fields that are filled automatically with the id of the chosen taxonomy
      # and manufacturer in the search popup
      find("#inventory_item_taxonomy_id").value.should == "#{@taxonomy.id}"
      find("#inventory_item_manufacturer_id").value.should == "#{@manufacturer.id}"

      click_button "submit"

      current_path.should == admin_inventory_items_path
      page.should have_content "Air Max"
    end
  end
end
