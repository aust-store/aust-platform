# encoding: utf-8
require 'acceptance_spec_helper'

feature "Managing Themes" do
  before do
    login_into_admin
    stub_subdomain(@admin_user.company)
    @company = @admin_user.company

    @default_theme = create(:theme)
    @second_theme  = create(:theme, :flat_pink)
    @another_company_theme  = create(:theme, :private)
    @own_company_theme      = create(:theme, :private,
                                     name: "OwnPrivate",
                                     path: "own_private",
                                     company_id: @company.id)
  end

  scenario "As an Admin, I change my store's theme" do
    @company.theme.should == @default_theme

    visit admin_marketing_index_path
    click_link "themes"

    page.should have_content @default_theme.name
    page.should have_content @second_theme.name
    page.should have_content @own_company_theme.name

    within ".theme.current" do
      page.should have_content @default_theme.name
      page.should_not have_content @own_company_theme.name
      page.should_not have_content @second_theme.name
      page.should_not have_content @another_company_theme.name
    end

    within "[title='#{@second_theme.path}']" do
      click_on "select_theme"
    end
    @company.reload
    @company.theme.should == @second_theme

    within ".theme.current" do
      page.should_not have_content @default_theme.name
      page.should have_content @second_theme.name
    end
  end
end