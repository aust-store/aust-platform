# encoding: utf-8
require 'acceptance_spec_helper'

feature "Inventory Item form" do
  let(:image_path) { "#{Rails.root.to_s}/spec/support/fixtures/image.png" }

  before do
    @admin_user   = FactoryGirl.create(:admin_user)
    @company      = @admin_user.company
    @taxonomy     = FactoryGirl.create(:taxonomy, name: "Shirt", store: @company)
    @taxonomy2    = FactoryGirl.create(:taxonomy, name: "Tennis", store: @company)
    @manufacturer = FactoryGirl.create(:manufacturer,
                                       name: "Github",
                                       admin_user: @admin_user,
                                       company: @company)
    login_into_admin
  end

  context "new inventory item" do
    before do
      visit admin_inventory_items_path
      click_link "add_item"
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

      fill_in "inventory_item_barcode", with: "123456789"
      fill_in "inventory_item_description", with: "Item description"
      attach_file "inventory_item_images_attributes_0_image", image_path
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

      created_item.barcode.should == "123456789"
      created_item.description.should == "Item description"
      created_item.price.should == 12.34
      created_item.images.first.image.file.file.should =~ /image\.png/
      created_item.images.first.cover.should be_true

      created_item.shipping_box.width .should == 25
      created_item.shipping_box.height.should == 25
      created_item.shipping_box.length.should == 25
      created_item.shipping_box.weight.should == 25
      created_item.entries.first.website_sale.should be_true
      created_item.entries.first.point_of_sale.should be_false

      manufacturers = Manufacturer.all
      manufacturers.map(&:name)         .should =~ ["Github", "My custom manufacturer"]
      manufacturers.map(&:company_id)   .should =~ [@company.id, @company.id]
      manufacturers.map(&:admin_user_id).should =~ [@admin_user.id, @admin_user.id]
    end

    scenario "As a store admin, I see validation errors if I miss some field" do

      # leaves all fields blank
      click_button "submit"

      current_path.should == admin_inventory_items_path

      page.should_not have_content "taxonomy_id"
      page.should_not have_content "manufacturer_id"
      page.should_not have_content "Fabricante deve estar presente"
      page.should have_content "Categoria não pode ser vazia"
      page.should have_content "Nome não pode ficar em branco"
      page.should have_content "Preço não pode ficar em branco"
      page.should have_content "Quantidade não pode ficar em branco"
      page.should have_content "Custo unitário não pode ficar em branco"
    end
  end

  context "existing inventory item" do
    before do
      @item = FactoryGirl.create(:inventory_item,
                                 taxonomy: @taxonomy,
                                 manufacturer: @manufacturer,
                                 name: "Air Max",
                                 description: "Item description",
                                 company: @company)

      visit edit_admin_inventory_item_path(@item)
    end

    scenario "As a store admin, I fill in the form and have my item updated" do

      # checks if the fields have the correct values
      find("#inventory_item_taxonomy_attributes_name").value.should == "Shirt"
      find("#inventory_item_manufacturer_attributes_name").value.should == "Github"
      find("#inventory_item_year").value.should == "2011"
      find("#inventory_item_name").value.should == "Air Max"

      find("#inventory_item_description").value.should == "Item description"
      find("#inventory_item_prices_attributes_0_value").value.should == "R$ 12,34"
      find("#inventory_item_shipping_box_attributes_length").value.should == "18.5cm"
      find("#inventory_item_shipping_box_attributes_height").value.should == "5cm"
      find("#inventory_item_shipping_box_attributes_width").value.should  == "14.5cm"
      find("#inventory_item_shipping_box_attributes_weight").value.should == "10kg"

      page.should_not have_field "inventory_item_images_attributes_0_image"
      page.should_not have_selector(".entry")
      page.should_not have_selector(".entry_1")
      page.should_not have_selector(".entry_2")

      # Editing
      #
      # fields used for searching existing items
      fill_in "inventory_item_taxonomy_attributes_name", with: "tennis"

      # New manufacturer
      fill_in "inventory_item_manufacturer_attributes_name", with: "Olympikus"
      fill_in "inventory_item_year", with: "2013"
      fill_in "inventory_item_name", with: "Air Max 2"

      fill_in "inventory_item_description", with: "Second description"
      fill_in "inventory_item_prices_attributes_0_value", with: "R$ 12,35"
      fill_in "inventory_item_shipping_box_attributes_length", with: "19cm"
      fill_in "inventory_item_shipping_box_attributes_height", with: "4cm"
      fill_in "inventory_item_shipping_box_attributes_width" , with: "15cm"
      fill_in "inventory_item_shipping_box_attributes_weight", with: "9kg"

      # fields that are filled automatically with the id of the chosen taxonomy
      find("#inventory_item_taxonomy_id").set "#{@taxonomy2.id}"
      find("#inventory_item_manufacturer_id").set ""

      click_button "submit"

      current_path.should == admin_inventory_item_path(@item)
      page.should have_content "Air Max"

      # Assert edited item
      created_item = InventoryItem.includes(:taxonomy).includes(:manufacturer).last
      created_item.taxonomy.name.should == "Tennis"
      created_item.manufacturer.name.should == "Olympikus"
      created_item.year.should == 2013
      created_item.name.should == "Air Max 2"
      created_item.description.should == "Second description"
      created_item.price.should == 12.35

      created_item.shipping_box.length.should == 19
      created_item.shipping_box.height.should == 4
      created_item.shipping_box.width .should == 15
      created_item.shipping_box.weight.should == 9

      manufacturer = created_item.manufacturer
      # Edits again to make sure manufacturers aren't created duplicated
      #
      # Attempt 1: defining an ID
        visit edit_admin_inventory_item_path(@item)
        fill_in "inventory_item_manufacturer_attributes_name", with: "Olympikus"
        find("#inventory_item_manufacturer_id").set "#{manufacturer.id}"

        click_button "submit"

      #
      # Attempt 2: with no ID, define name of manufacturer that already exists
        visit edit_admin_inventory_item_path(@item)
        fill_in "inventory_item_manufacturer_attributes_name", with: "Olympikus"
        find("#inventory_item_manufacturer_id").set ""

        click_button "submit"

        edited_item = InventoryItem.includes(:taxonomy).includes(:manufacturer).last
        edited_item.manufacturer.should == manufacturer

      manufacturers = Manufacturer.all
      manufacturers.map(&:name)         .should == ["Github", "Olympikus"]
      manufacturers.map(&:company_id)   .should == [@company.id, @company.id]
      manufacturers.map(&:admin_user_id).should == [@admin_user.id, @admin_user.id]
    end
  end
end
