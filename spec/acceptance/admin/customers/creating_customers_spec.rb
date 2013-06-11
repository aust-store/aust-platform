require 'spec_helper'

feature "Creating customers" do

  background { login_into_admin }

  let(:customer)      { FactoryGirl.build(:customer, company: @company) }
  let!(:old_customer) do
    FactoryGirl.create( :customer,
                        first_name: "Hey",
                        last_name: "Jude",
                        company: @company)
  end

  describe "Adding new customer" do
    scenario "As an admin, I'd like to add new customers" do
      visit admin_customers_path
      page.should have_content(old_customer.name)
      click_link "Novo cliente"
      fill_in "customer_first_name",with: customer.first_name
      fill_in "customer_last_name", with: customer.last_name
      fill_in "customer_description", with: customer.description
      click_button "salvar_cliente"
      click_link customer.name
      page.should have_content(customer.name)
      page.should_not have_content(old_customer.name)
    end
  end
end
