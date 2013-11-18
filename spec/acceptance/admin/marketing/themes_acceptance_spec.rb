# encoding: utf-8
require 'acceptance_spec_helper'

feature "Managing Themes" do
  before do
    login_into_admin
    @company = @admin_user.company

    @default_theme = create(:theme)
  end

  scenario "As an admin, I can create a new theme for my store" do
    visit admin_store_themes_path
    Theme.count.should == 1
    all(".theme_item").size.should == 1
    click_on "new_theme"

    visit admin_store_themes_path
    Theme.count.should == 2
    all(".theme_item").size.should == 2
    last_theme = Theme.last
    last_theme.company.should == @company
  end

  context "changing themes" do
    background do
      @second_theme  = create(:theme, :flat_pink)
      @another_company_theme  = create(:theme, :private)
      @own_company_theme      = create(:theme, :private,
                                       name: "OwnPrivate",
                                       path: "own_private",
                                       company_id: @company.id)
    end

    scenario "As an admin, I change my store's theme" do
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
end
