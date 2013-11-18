# encoding: utf-8
require 'acceptance_spec_helper'

feature "Company contact" do
  before do
    login_into_admin
    stub_subdomain(@admin_user.company)
  end

  scenario "As an Admin, I manage the company contact information" do
    visit admin_settings_path

    click_link "edit_company_contact_link"

    # submit an empty form to assert the error
    click_on "submit"
    page.should have_content I18n.t("admin.default_messages.update.failure")

    fill_in "company_address_attributes_address_1",    with: "Baker street"
    fill_in "company_address_attributes_number",       with: "221B"
    fill_in "company_address_attributes_address_2",    with: "I don't know"
    fill_in "company_address_attributes_neighborhood", with: "Central London"
    fill_in "company_address_attributes_zipcode",      with: "96360000"
    fill_in "company_address_attributes_city",         with: "London"
    select "Rio Grande do Sul", from: "company_address_attributes_state"

    fill_in "company_contact_attributes_phone_1", with: "12345678"
    fill_in "company_contact_attributes_phone_2", with: "12345679"
    fill_in "company_contact_attributes_email",   with: "company@example.com"

    click_on "submit"

    page.should have_content I18n.t("admin.default_messages.update.success")
    address = @company.address
    contact = @company.contact
    contact.reload

    address.address_1.should    == "Baker street"
    address.address_2.should    == "I don't know"
    address.city.should         == "London"
    address.zipcode.should      ==  "96360000"
    address.state.should        == "RS"
    address.country.should      == "BR"
    address.default.should      == true
    address.neighborhood.should == "Central London"
    address.number.should       == "221B"

    contact.phone_1.should == "12345678"
    contact.phone_2.should == "12345679"
    contact.email.should   == "company@example.com"
  end
end
