# encoding: utf-8
require 'acceptance_spec_helper'

feature "Managing Themes" do
  let(:default_theme) { create(:theme) }

  before do
    login_into_admin
    @company = @admin_user.company

    default_theme
  end

  scenario "As an admin, I can create a new theme for my store and edit it" do
    visit admin_store_themes_path
    Theme.count.should == 1
    all(".theme_item").size.should == 1
    click_on "new_theme"

    # just created theme
    created_theme = Theme.last
    created_theme.company.should == @company

    # the theme editor is not opened
    current_path.should == admin_store_themes_path

    # the new theme appears in the themes list
    visit admin_store_themes_path
    Theme.count.should == 2
    all(".theme_item").size.should == 2

    within ".theme_#{created_theme.id}" do
      click_on "Editar tema"
    end

    # the theme editor is then opened
    current_path.should == admin_theme_editor_path(created_theme)
  end

  describe "changing themes" do
    background do
      @second_theme  = create(:theme, :flat_pink)
      @another_company_theme  = create(:theme, :private)
      @own_company_theme      = create(:theme, :private,
                                       name: "OwnPrivate",
                                       path: "own_private",
                                       company_id: @company.id)
    end

    scenario "As an admin, I change my store's theme" do
      @company.theme.should == default_theme

      visit admin_marketing_index_path
      click_link "themes"

      page.should have_content default_theme.name
      page.should have_content @second_theme.name
      page.should have_content @own_company_theme.name

      within ".theme.current" do
        page.should have_content default_theme.name
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
        page.should_not have_content default_theme.name
        page.should have_content @second_theme.name
      end
    end
  end
end
