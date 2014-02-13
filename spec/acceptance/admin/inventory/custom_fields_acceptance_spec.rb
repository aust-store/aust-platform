require 'acceptance_spec_helper'

feature "Admin/InventoryItems/CustomFields" do
  let!(:other_company) { create(:barebone_company) }
  let!(:company)    { create(:barebone_company, handle: "mystore") }
  let!(:admin_user) { create(:admin_user, company: company) }
  let!(:taxonomy1)  { create(:taxonomy, store: company) }
  let!(:taxonomy2)  { create(:taxonomy, store: company) }

  background do
    login_into_admin as: admin_user
    visit admin_inventory_custom_fields_path
  end

  scenario "As an admin, I create a new custom field" do
    click_link "add_custom_field"
    fill_in "custom_field_name", with: "My Note"
    check "custom_field_taxonomy_ids_#{taxonomy1.id}"

    click_button "submit"

    resource = CustomField.last
    resource.company_id.should == company.id
    resource.related_type.should == "InventoryItem"
    resource.name.should == "My Note"
    resource.alphanumeric_name.should == "my_note"
    resource.taxonomies.should == [taxonomy1]

    page.should have_content "Note"
    page.should have_content "my_note"
    page.should have_content taxonomy1.name
    page.should_not have_content taxonomy2.name
  end
end
