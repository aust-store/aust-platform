# encoding: utf-8
require 'acceptance_spec_helper'

feature "Inventory Item creation" do
  before do
    @admin_user = FactoryGirl.create(:admin_user)
    @company = @admin_user.company
    @taxonomy = FactoryGirl.create(:taxonomy, name: "Shirt", store: @company)
    @manufacturer = FactoryGirl.create(:manufacturer,
                                       name: "Github",
                                       admin_user: @admin_user,
                                       company: @company)
    login_into_admin
  end

  context "new inventory item" do
    before do
      visit admin_inventory_items_path
      click_link "Adicionar item"
    end

    scenario "As a store admin, I fill in the form and have my item created" do

      # fields used for searching existing items
      #
      # In the manufacturer, the user can type new names that are going to be
      # created automatically.
      fill_in "inventory_item_manufacturer_attributes_name", with: "My custom manufacturer"
      fill_in "inventory_item_taxonomy_attributes_name", with: "Shirt"
      fill_in "inventory_item_year", with: "2013"
      fill_in "inventory_item_name", with: "Air Max"

      fill_in "inventory_item_description", with: "Item description"
      fill_in "inventory_item_prices_attributes_0_value", with: "R$ 12,34"
      fill_in "inventory_item_shipping_box_attributes_length", with: 25
      fill_in "inventory_item_shipping_box_attributes_height", with: 25
      fill_in "inventory_item_shipping_box_attributes_width" , with: 25
      fill_in "inventory_item_shipping_box_attributes_weight", with: 25

      within(".entry") do
        fill_in "inventory_item_entries_attributes_0_quantity", with: "50"
        fill_in "inventory_item_entries_attributes_0_cost_per_unit", with: "R$ 6,12"
      end

      # fields that are filled automatically with the id of the chosen taxonomy
      find("#inventory_item_taxonomy_id").set "#{@taxonomy.id}"

      click_button "submit"

      current_path.should == admin_inventory_items_path

      page.should have_content "Air Max"

      created_item = InventoryItem.includes(:taxonomy).includes(:manufacturer).last
      created_item.taxonomy.name.should == "Shirt"
      created_item.manufacturer.name.should == "My custom manufacturer"
      created_item.year.should == 2013
      created_item.name.should == "Air Max"

      created_item.description.should == "Item description"
      created_item.price.should == 12.34

      manufacturers = Manufacturer.all
      manufacturers.map(&:name)         .should == ["Github", "My custom manufacturer"]
      manufacturers.map(&:company_id)   .should == [@company.id, @company.id]
      manufacturers.map(&:admin_user_id).should == [@admin_user.id, @admin_user.id]
    end

    scenario "As a store admin, I see validation errors if I miss some field" do

      # leaves all fields blank
      click_button "submit"

      current_path.should == admin_inventory_items_path

      page.should_not have_content "taxonomy_id"
      page.should_not have_content "manufacturer_id"
      page.should have_content "Fabricante deve estar presente"
      page.should have_content "Categoria não pode ser vazia"
      page.should have_content "Nome não pode ficar em branco"
      page.should have_content "Preço não pode ficar em branco"
      page.should have_content "Você deve especificar a Quantidade"
      page.should have_content "Você deve especificar o Custo unitário"
    end
  end
end
