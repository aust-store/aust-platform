# -*- coding: utf-8 -*-

require 'spec_helper'

feature "Customers" do

  before do
    login_into_admin
    @customer = Factory.build(:customer)
    @old_customer = Factory.create(:customer, first_name: "Rafael",last_name: "Oliveira", company_id: '2')
  end

  describe "Adding new customer" do
    scenario "As a admin, I'd like to add new customers" do

      visit admin_customers_path
      click_link "Novo cliente"
      fill_in "customer_first_name",with: @customer.first_name
      fill_in "customer_last_name", with: @customer.last_name
      fill_in "customer_description", with: @customer.description
      click_button "salvar_cliente"
      page.should have_content(@customer.name)
      page.should_not have_content(@old_customer.name)

    end
  end
end
