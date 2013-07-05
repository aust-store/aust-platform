# coding: utf-8
require 'acceptance_spec_helper'

feature "Store's front-page" do
  before do
    @company = FactoryGirl.create(:company, handle: "company")
  end

  context "Existing company" do
    scenario "As a customer, I access a specific store" do
      switch_to_subdomain("company")
      visit root_path
      page.should have_content(@company.name)
    end
  end

  context "Inexistent company" do
    scenario "As a customer, I'm redirected to the marketing page" do
      switch_to_subdomain("something")
      visit root_path
      current_path.should == marketing_root_path(subdomain: false)
    end
  end
end
