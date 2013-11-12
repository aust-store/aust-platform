require 'spec_helper'

feature "Updating a customer" do

  background { login_into_admin }

  let!(:customer) do
    FactoryGirl.create(:customer,
                       first_name: "Hey",
                       last_name: "Jude",
                       store: @company)
  end

  describe "Update a customer" do
    scenario "As an admin, I'd like to update customers" do
      visit admin_customers_path
      click_link customer.first_name
      click_link "Editar"
      fill_in "customer_first_name",with: "Freddie"
      fill_in "customer_last_name", with: "Mercury"
      click_button "Salvar cliente"
      page.should have_content("Freddie")
      page.should have_content("Mercury")
    end
  end
end
