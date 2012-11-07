# coding: utf-8
require 'acceptance_spec_helper'

feature "Store catalog's front-page" do
  background do
    @company_one = FactoryGirl.create(:company, name: "ACME", handle: "ACME")
    @company_two = FactoryGirl.create(:company, name: "Easy Company", handle: "two")

    @item_one = FactoryGirl.create(:inventory_item, company: @company_one)
    @item_two = FactoryGirl.create(:inventory_item_two, company: @company_two)
  end

  describe "Store listing" do
    scenario "As a customer, I access a store through the catalog" do
      visit root_path

      page.should have_content(@company_one.name)
      page.should have_content(@company_two.name)

      click_link @company_one.name

      current_path.should == store_path(@company_one.handle)

      page.should have_content(@item_one.name)
      page.should_not have_content(@item_two.name)
    end
  end
end
