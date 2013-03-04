# coding: utf-8
require 'acceptance_spec_helper'

feature "Store's front-page" do
  before do
    @company = FactoryGirl.create(:company)
    stub_subdomain(@company)

    inventory_entry_one   = FactoryGirl.create(:inventory_entry)
    inventory_entry_two   = FactoryGirl.create(:inventory_entry)
    inventory_entry_three = FactoryGirl.create(:inventory_entry)
    @item = FactoryGirl.create(:inventory_item, company: @company, balances: [
                                 inventory_entry_one,
                                 inventory_entry_two,
                                 inventory_entry_three
                               ])
    inventory_entry_one.update_attribute(:quantity, 0)
  end

  describe "Accessing a company's store" do
    scenario "As a customer, I access a specific store" do
      visit root_path
      page.should have_content(@company.name)

      within(".cart_status") do
        page.should have_content("Seu carrinho está vazio.")
      end

      # the correct price is shown
      page.should have_content @item.name
      page.should have_content "R$ 12,34"
    end
  end

  describe "Showing highlight products in the main page" do
    scenario "As a customer, I see a list of highlight products, max 12 results" do
      12.times do |i|
        inventory_entry = FactoryGirl.create(:inventory_entry)
        FactoryGirl.create(:inventory_item, name: "Item #{i}", company: @company, balances: [inventory_entry])
      end

      visit root_path
      page.should have_content(@company.name)

      n = 11
      12.times do |p|
        within(".product_#{p}") do
          page.should have_content "Item #{n}"
          page.has_css?("image_#{p}")
          page.should have_content "R$ 12,34"
        end
        n -= 1
      end
    end
  end
end
