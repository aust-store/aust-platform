require 'spec_helper'

feature "Admin/Customer" do
  let(:customer) { create(:customer, store: @company) }

  background do
    login_into_admin
  end

  scenario "As admin, I can see the customer details" do
    customer = nil

    Timecop.travel(Time.utc(2013, 8, 9, 10, 10, 10)) do
      customer = create(:customer, store: @company)
    end

    Timecop.travel(Time.utc(2013, 8, 8, 10, 10, 10)) do
      visit admin_customer_path(customer)

      page.should have_content customer.first_name
      page.should have_content customer.last_name
      page.should have_content customer.email
      page.should have_content customer.social_security_number
      page.should have_content "#{customer.home_area_number} #{customer.home_number}"
      page.should have_content "1 dia atrás"
    end
  end

  describe "creating a customer" do
    scenario "As an admin, I create a customer" do
      Customer.count.should == 0

      visit admin_customers_path
      page.should_not have_content "Freddie"
      click_on "add_item"

      fill_in "customer_email",                               with: "sherlock@holmes.com"
      fill_in "customer_first_name",                          with: "Freddie"
      fill_in "customer_last_name",                           with: "Mercury"
      fill_in "customer_password",                            with: "guess_my_password"
      fill_in "customer_password_confirmation",               with: "guess_my_password"
      fill_in "customer_social_security_number",              with: "141.482.543-93"
      fill_in_phones
      fill_in_address
      click_button "submit"

      current_path.should == admin_customers_path
      page.should have_content "Freddie Mercury"
      Customer.last.environment.should == "admin"
    end
  end

  describe "editing a customer" do
    before do
      customer
    end

    scenario "As an admin, I update a customers" do
      visit admin_customers_path
      click_link customer.first_name
      click_link "Editar"

      current_path.should == edit_admin_customer_path(customer)
      find("#customer_receive_newsletter").value.should === "1"
      fill_in "customer_first_name", with: "Freddie"
      fill_in "customer_last_name", with: "Mercury"
      click_button "submit"

      current_path.should == admin_customer_path(customer)
      page.should have_content "Freddie"
      page.should have_content "Mercury"
    end
  end

  describe "deleting a customer" do
    before do
      customer
    end

    scenario "As an admin, I want to like to delete a customer" do
      customer.enabled.should == true
      visit admin_customers_path

      page.should have_content customer.first_name
      page.should have_content customer.last_name

      click_link customer.first_name
      click_link "Desativar"

      page.should have_content I18n.t('admin.customers.notice.delete')
      current_path.should == admin_customers_path
      customer.reload.enabled.should == false
    end
  end

  def fill_in_address
    fill_in "customer_addresses_attributes_0_address_1",    with: "Baker street"
    fill_in "customer_addresses_attributes_0_number",       with: "221B"
    fill_in "customer_addresses_attributes_0_address_2",    with: "I don't know"
    fill_in "customer_addresses_attributes_0_neighborhood", with: "Central London"
    fill_in "customer_addresses_attributes_0_zipcode",      with: "96360000"
    fill_in "customer_addresses_attributes_0_city",         with: "London"
    select "Rio Grande do Sul", from: "customer_addresses_attributes_0_state"
  end

  def fill_in_phones
    fill_in "customer_home_number",                         with: "1234-1234"
    fill_in "customer_home_area_number",                    with: "53"
    fill_in "customer_mobile_number",                       with: "1234-1234"
    fill_in "customer_mobile_area_number",                  with: "53"
  end
end
