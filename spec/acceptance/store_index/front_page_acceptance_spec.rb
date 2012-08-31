# coding: utf-8
require 'acceptance_spec_helper'

feature "Store catalog's front-page" do
  before do
    @company_one = FactoryGirl.create(:company, name: "ACME", handle: "ACME")
    @company_two = FactoryGirl.create(:company, name: "Easy Company", handle: "two")

    @good_one = FactoryGirl.create(:good, company: @company_one)
    @good_two = FactoryGirl.create(:good_two, company: @company_two)
  end

  describe "Store listing" do
    scenario "As a customer, I access a store through the catalog" do
      visit root_path

      page.should have_content(@company_one.name)
      page.should have_content(@company_two.name)

      click_link @company_one.name

      current_path.should == store_path(@company_one.handle)

      page.should have_content(@good_one.name)
      page.should_not have_content(@good_two.name)
    end
  end
end
