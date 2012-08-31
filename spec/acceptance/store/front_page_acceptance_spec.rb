# coding: utf-8
require 'acceptance_spec_helper'

feature "Store's front-page" do
  before do
    @company = FactoryGirl.create(:company)
  end

  describe "Accessing a company's store" do
    scenario "As a customer, I access a specific store" do
      visit store_path(@company.handle)
      page.should have_content(@company.name)

      within(".cart_status") do
        page.should have_content("Seu carrinho está vazio.")
      end
    end
  end
end
