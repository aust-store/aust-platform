# encoding: utf-8
require "acceptance_spec_helper"

feature "Store Sign Up" do
  before do
    @company = FactoryGirl.create(:company)
    @product = FactoryGirl.create(:inventory_item, company: @company)
    stub_subdomain(@company)
    stub_shipping_calculation_enabled(true)
  end

  scenario "As an user, I can sign up when checking out", js: true do
    stub_shipping

    # Product page
    inventory_entry = @product.balances.first
    visit product_path(inventory_entry)
    click_link "Adicionar ao carrinho"

    # Cart page
    within(".js_service_selection") { choose("type_pac") }
    fill_in "zipcode", with: "96360000"

    page.should have_content "R$ 12,34"
    page.should have_content "entrega em 3 dias úteis"
    click_on "checkout_button"

    # Sign in page
    fill_in "user_email", with: "user@example.com"
    choose("has_no_password")
    click_on "sign_in"

    # Sign up page
    page.should have_content "Nova conta"

    within ".contact_info" do
      page.should have_content "Telefone residencial"
      page.should have_content "Celular"
    end

    fill_in "user_email",                               with: "sherlock@holmes.com"
    fill_in "user_first_name",                          with: "Sherlock"
    fill_in "user_last_name",                           with: "Holmes"
    fill_in "user_password",                            with: "guess_my_password"
    fill_in "user_password_confirmation",               with: "guess_my_password"
    fill_in "user_home_number",                         with: "1234-1234"
    fill_in "user_home_area_number",                    with: "53"
    fill_in "user_mobile_number",                       with: "1234-1234"
    fill_in "user_mobile_area_number",                  with: "53"
    fill_in "user_social_security_number",              with: "141.482.543-93"
    fill_in "user_addresses_attributes_0_address_1",    with: "Baker street"
    fill_in "user_addresses_attributes_0_number",       with: "221B"
    fill_in "user_addresses_attributes_0_address_2",    with: "I don't know"
    fill_in "user_addresses_attributes_0_neighborhood", with: "Central London"
    fill_in "user_addresses_attributes_0_zipcode",      with: "96360000"
    fill_in "user_addresses_attributes_0_city",         with: "London"
    fill_in "user_addresses_attributes_0_state",        with: "LO"
    click_button "sign_up_button"

    # sets the default address
    user = User.where(email: 'sherlock@holmes.com').first
    user.store.should == @company
    user.addresses.first.default.should == true

    # Ends up in the shipping page
    page.should have_content I18n.t('store.checkout.shipping.show.page_title')
  end
end
