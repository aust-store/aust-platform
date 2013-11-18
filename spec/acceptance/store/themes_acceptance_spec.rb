# encoding: utf-8
require 'acceptance_spec_helper'

feature "Stores themes" do
  background do
    @company = FactoryGirl.create(:company, theme: @theme)
    stub_subdomain(@company)
  end

  context "vertical taxonomy menu" do
    background do
      @theme = FactoryGirl.create(:theme, :minimalism)
      @company.theme = @theme
      @company.save
    end

    scenario "As a visitor, I can see a vertical taxonomy menu in the minimalism theme" do
      visit root_path
      page.should have_selector ".taxonomy_menu.vertical_taxonomy_menu"
    end
  end

  context "no vertical taxonomy menu" do
    background do
      @theme = FactoryGirl.create(:theme, :overblue)
      @company.theme = @theme
      @company.save
    end

    scenario "As a visitor, I can see a vertical taxonomy menu in the minimalism theme" do
      visit root_path
      page.should_not have_selector ".taxonomy_menu.vertical_taxonomy_menu"
    end
  end

  describe "edge cases" do
    let(:company) { create(:barebone_company, :minimalism_theme) }

    background do
      stub_subdomain(company)
    end

    scenario "As a customer, I access a company without any data at all" do
      visit root_path
      page.should have_content(company.name)
    end
  end
end
