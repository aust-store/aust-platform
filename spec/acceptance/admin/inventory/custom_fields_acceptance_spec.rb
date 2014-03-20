require 'acceptance_spec_helper'

feature "Admin/InventoryItems/CustomFields" do
  let!(:other_company) { create(:barebone_company) }
  let!(:company)    { create(:barebone_company, handle: "mystore") }
  let!(:admin_user) { create(:admin_user, company: company) }
  let!(:taxonomy1)  { create(:taxonomy, store: company) }
  let!(:taxonomy2)  { create(:taxonomy, store: company) }
  let(:custom_field) { create(:custom_field, taxonomies: [taxonomy2], company: company) }

  background do
    company
    login_into_admin as: admin_user
    visit admin_inventory_custom_fields_path
  end

  describe "managing custom fields" do
    scenario "As an admin, I create a new custom field" do
      click_link "add_custom_field"
      fill_in "custom_field_name", with: "My Note"
      check "custom_field_taxonomy_ids_#{taxonomy1.id}"

      click_button "submit"

      page.should have_content "Note"
      page.should have_content "my_note"
      page.should have_content taxonomy1.name
      page.should_not have_content taxonomy2.name

      resource = CustomField.last
      resource.company_id.should == company.id
      resource.related_type.should == "InventoryItem"
      resource.name.should == "My Note"
      resource.alphanumeric_name.should == "my_note"
      resource.taxonomies.should == [taxonomy1]
    end

    scenario "As an admin, I edit a custom field" do
      custom_field

      resource = CustomField.last
      resource.taxonomies.should == [taxonomy2]

      visit edit_admin_inventory_custom_field_path(custom_field)
      page.should have_checked_field("custom_field_taxonomy_ids_#{taxonomy2.id}")
      page.should_not have_checked_field("custom_field_taxonomy_ids_#{taxonomy1.id}")
      find("#custom_field_name").value.should == custom_field.name

      check("custom_field_taxonomy_ids_#{taxonomy1.id}")
      uncheck("custom_field_taxonomy_ids_#{taxonomy2.id}")

      click_button "submit"

      resource = CustomField.last
      resource.taxonomies.should == [taxonomy1]
    end
  end

  describe "behavior of custom fields" do
    background do
      click_link "add_custom_field"
      fill_in "custom_field_name", with: "My Note"
      check "custom_field_taxonomy_ids_#{taxonomy1.id}"
    end

    context "text field" do
      let(:custom_field) { create(:custom_field, taxonomies: [taxonomy2], company: company) }

      scenario "As admin, I see the field in the inventory item form" do
        select "Texto", from: :custom_field_field_type
        click_button "submit"
        page.should have_content "My Note"

        visit new_admin_inventory_item_path
        page.should have_content "My Note"
        page.should have_field "inventory_item_custom_fields_my_note"

        fill_in "inventory_item_custom_fields_my_note", with: "Super note"

        fill_in_inventory_item
        item = InventoryItem.last
        item.custom_fields["my_note"].should == "Super note"

        visit edit_admin_inventory_item_path(item)
        find_field("inventory_item_custom_fields_my_note").value.should == "Super note"
      end
    end

    context "radio field" do
      scenario "As admin, I see the field in the inventory item form" do
        select "Seleção", from: :custom_field_field_type
        fill_in :custom_field_options_values_0, with: "Radio1"
        fill_in :custom_field_options_values_1, with: "Radio2"
        click_button "submit"
        page.should have_content "My Note"

        visit new_admin_inventory_item_path
        page.should have_content "My Note"
        page.should have_field "inventory_item_custom_fields_my_note_radio1"
        page.should have_field "inventory_item_custom_fields_my_note_radio2"

        choose "inventory_item_custom_fields_my_note_radio2"

        fill_in_inventory_item
        item = InventoryItem.last
        item.custom_fields["my_note"].should == "Radio2"

        visit edit_admin_inventory_item_path(item)
        find_field("inventory_item_custom_fields_my_note_radio1")[:checked].should be_false
        find_field("inventory_item_custom_fields_my_note_radio2")[:checked].should be_true
      end
    end
  end

  def fill_in_inventory_item
    prefix = "inventory_item"

    fill_in "#{prefix}_manufacturer_attributes_name", with: "My custom manufacturer"
    fill_in "#{prefix}_taxonomy_attributes_name", with: "Shirt"
    fill_in "#{prefix}_year", with: "2013"
    fill_in "#{prefix}_name", with: "Air Max"

    fill_in "#{prefix}_prices_attributes_0_value", with: "R$ 12,34"

    fill_in "#{prefix}_shipping_box_attributes_length", with: 25
    fill_in "#{prefix}_shipping_box_attributes_height", with: 25
    fill_in "#{prefix}_shipping_box_attributes_width" , with: 25
    fill_in "#{prefix}_shipping_box_attributes_weight", with: 25

    within(".entry") do
      fill_in "#{prefix}_entries_attributes_0_quantity", with: "50"
      fill_in "#{prefix}_entries_attributes_0_cost_per_unit", with: "R$ 6,12"
    end

    # fields that are filled automatically with the id of the chosen taxonomy
    find("##{prefix}_taxonomy_id").set "#{taxonomy1.id}"

    click_button "submit"

    current_path.should == admin_inventory_items_path
    page.should have_content "Air Max"
  end
end
