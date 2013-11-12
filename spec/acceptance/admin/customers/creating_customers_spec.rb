require 'spec_helper'

feature "Creating customers" do
  let(:customer) { FactoryGirl.build(:customer, store: @company) }
  let(:old_customer) do
    FactoryGirl.create(:customer,
                        first_name: "Hey",
                        last_name: "Jude",
                        store: @company)
  end

  background do
    login_into_admin
    old_customer
  end

  describe "Adding new customer" do
    pending "As an admin, I'd like to add new customers" do
      visit admin_customers_path
      page.should have_content old_customer.first_name
      click_link "Novo cliente"
      fill_in "customer_first_name",with: customer.first_name
      fill_in "customer_last_name", with: customer.last_name
      click_button "salvar_cliente"
      click_link customer.first_name
      page.should have_content(customer.first_name)
      page.should_not have_content(old_customer.first_name)
    end
  end
end
