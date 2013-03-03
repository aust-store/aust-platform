require 'acceptance_spec_helper'

feature "Inventory Item edition" do
  before do
    @admin_user    = FactoryGirl.create(:admin_user)
    @company       = @admin_user.company

    @taxonomy      = FactoryGirl.create(:taxonomy,     name: "Shirt",  store: @company)
    @taxonomy2     = FactoryGirl.create(:taxonomy,     name: "Tennis", store: @company)
    @manufacturer  = FactoryGirl.create(:manufacturer, name: "Nike",   company: @company)
    @manufacturer2 = FactoryGirl.create(:manufacturer, name: "Asics",  company: @company)
    @item          = FactoryGirl.create(:inventory_item,
                                        taxonomy: @taxonomy,
                                        manufacturer: @manufacturer,
                                        name: "Air Max",
                                        description: "Item description",
                                        company: @company)

    login_into_admin
  end

  context "new inventory item" do
    before do
      visit edit_admin_inventory_item_path(@item)
    end

    scenario "As a store admin, I fill in the form and have my item updated" do

      # checks if the fields have the correct values
      find("#inventory_item_taxonomy_attributes_name").value.should == "Shirt"
      find("#inventory_item_manufacturer_attributes_name").value.should == "Nike"
      find("#inventory_item_year").value.should == "2011"
      find("#inventory_item_name").value.should == "Air Max"

      find("#inventory_item_description").value.should == "Item description"
      find("#inventory_item_prices_attributes_0_value").value.should == "R$ 12,34"
      find("#inventory_item_shipping_box_attributes_length").value.should == "18.5cm"
      find("#inventory_item_shipping_box_attributes_height").value.should == "5cm"
      find("#inventory_item_shipping_box_attributes_width").value.should  == "14.5cm"
      find("#inventory_item_shipping_box_attributes_weight").value.should == "10kg"

      page.should_not have_selector(".entry_1")
      page.should_not have_selector(".entry_2")

      # Editing
      #
      # fields used for searching existing items
      fill_in "inventory_item_taxonomy_attributes_name", with: "tennis"
      fill_in "inventory_item_manufacturer_attributes_name", with: "asics"
      fill_in "inventory_item_year", with: "2013"
      fill_in "inventory_item_name", with: "Air Max 2"

      fill_in "inventory_item_description", with: "Second description"
      fill_in "inventory_item_prices_attributes_0_value", with: "R$ 12,34"
      fill_in "inventory_item_shipping_box_attributes_length", with: "19cm"
      fill_in "inventory_item_shipping_box_attributes_height", with: "4cm"
      fill_in "inventory_item_shipping_box_attributes_width" , with: "15cm"
      fill_in "inventory_item_shipping_box_attributes_weight", with: "9kg"

      # fields that are filled automatically with the id of the chosen taxonomy
      find("#inventory_item_taxonomy_id").set "#{@taxonomy2.id}"

      click_button "submit"

      current_path.should == admin_inventory_item_path(@item.id)
      page.should have_content "Air Max"
    end
  end
end
