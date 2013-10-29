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
      current_path.should == "/"
    end
  end

  context "Inexistent company" do
    context "Inexistent subdomain" do
      scenario "As a customer, I'm redirected to the marketing page" do
        switch_to_subdomain("something")
        visit root_path
        current_path.should == root_path(subdomain: false)
        page.should have_content "Marketing page"
      end
    end
  end

  context "Accessing the Marketing page manually" do
    scenario "As a customer accessing store.com, I'm go to the marketing page" do
      visit root_path(subdomain: false)
      current_path.should == root_path(subdomain: false)
      page.should have_content "Marketing page"
    end

    scenario "As a customer accessing www.store.com, I'm go to the marketing page" do
      switch_to_subdomain("www")
      visit root_path
      current_path.should == root_path(subdomain: "www")
      page.should have_content "Marketing page"
    end
  end
end
