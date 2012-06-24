# coding: utf-8
require 'acceptance_spec_helper'

feature "Store catalog's front-page" do
  before do
    @company_one = FactoryGirl.create(:company, name: "ACME")
    @company_two = FactoryGirl.create(:company, name: "Easy Company")
  end

  describe "Store listing" do
    scenario "As a customer, I access a store through the catalog" do
      visit store_index_path

      page.should have_content(@company_one.name)
      page.should have_content(@company_two.name)

      click_link @company_one.name

      current_path.should == store_path(@company_one.handle)
    end
  end
end
