# encoding: utf-8
require "acceptance_spec_helper"

feature "Store Sign Up" do
  before do
    stub_correios
    @company = FactoryGirl.create(:company_with_zipcode, handle: "mystore")
    @product = FactoryGirl.create(:inventory_item, company: @company)
    stub_subdomain(@company)
  end

  scenario "As a customer, I can sign up when checking out", js: true do
    stub_shipping

    # Product page
    visit product_path(@product)
    click_link I18n.t("store.products.show.add_to_cart_link")

    # Cart page
    within(".js_service_selection") { choose("type_pac") }
    fill_in "zipcode", with: "96360000"

    page.should have_content "R$ 12,34"
    page.should have_content "entrega em 3 dias úteis"
    click_on "checkout_button"

    # Sign in page
    fill_in "person_email", with: "person@example.com"
    page.should have_selector "#has_no_password"
    choose(I18n.t('session.new.labels.has_no_password'))
    click_on "sign_in"
    # Sign up page
    page.should have_content "Nova conta"

    within ".contact_info" do
      page.should have_content "Telefone residencial"
      page.should have_content "Celular"
    end

    fill_in "person_email",                               with: "sherlock@holmes.com"
    fill_in "person_first_name",                          with: "Sherlock"
    fill_in "person_last_name",                           with: "Holmes"
    fill_in "person_password",                            with: "guess_my_password"
    fill_in "person_password_confirmation",               with: "guess_my_password"
    fill_in "person_home_number",                         with: "1234-1234"
    fill_in "person_home_area_number",                    with: "53"
    fill_in "person_mobile_number",                       with: "1234-1234"
    fill_in "person_mobile_area_number",                  with: "53"
    fill_in "person_social_security_number",              with: "141.482.543-93"
    fill_in "person_addresses_attributes_0_address_1",    with: "Baker street"
    fill_in "person_addresses_attributes_0_number",       with: "221B"
    fill_in "person_addresses_attributes_0_address_2",    with: "I don't know"
    fill_in "person_addresses_attributes_0_neighborhood", with: "Central London"
    fill_in "person_addresses_attributes_0_zipcode",      with: "96360000"
    fill_in "person_addresses_attributes_0_city",         with: "London"
    select "Rio Grande do Sul", from: "person_addresses_attributes_0_state"
    check "person_receive_newsletter"
    click_button "sign_up_button"

    # Ends up in the shipping page
    page.should have_content I18n.t('store.checkout.shipping.show.page_title')

    # sets the default address
    customer = Person.where(email: 'sherlock@holmes.com').first
    customer.store.should == @company
    customer.receive_newsletter.should be_true
    customer.addresses.first.default.should == true
  end
end
