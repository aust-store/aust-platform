# coding: utf-8
require 'acceptance_spec_helper'

feature "Store's front-page" do
  before do
    @company = FactoryGirl.create(:company, handle: "company", domain: "petshop.com")
    switch_to_main_domain
  end

  describe "using a explicit subdomain" do
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

  describe "not entering a subdomain" do
    it "goes to the marketing page" do
      visit root_path(subdomain: false)
      current_path.should == marketing_root_path(subdomain: false)
    end
  end

  describe "entering the company's own domain" do
    it "goes to the company page" do
      Capybara.app_host = "http://petshop.com"
      Capybara.default_host = "http://petshop.com"
      visit root_path(subdomain: false)
      current_path.should == root_path(subdomain: false)
      page.should have_content(@company.name)
    end
  end
end
