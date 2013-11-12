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

  describe "editing a customer" do
    before do
      customer
    end

    scenario "As an admin, I update a customers" do
      visit admin_customers_path
      click_link customer.first_name
      click_link "Editar"

      current_path.should == edit_admin_customer_path(customer)
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
end
