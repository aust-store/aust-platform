# encoding: utf-8
require 'acceptance_spec_helper'

feature "Super admin themes management" do
  background do
    login_into_super_admin
    @company1 = FactoryGirl.create(:company)
    @company2 = FactoryGirl.create(:company)
  end

  scenario "As a super admin, I'm able to create and edit themes" do
    click_link "Temas"
    click_link "new_theme"

    current_path.should == new_super_admin_theme_path

    within "form#new_theme" do
      fill_in "theme_name",        with: "My theme"
      fill_in "theme_description", with: "description"
      fill_in "theme_path",        with: "my_theme"
      check   "theme_vertical_taxonomy_menu"
      check   "theme_public"
      click_button "commit"
    end

    theme = Theme.order("id").last
    theme.vertical_taxonomy_menu.should be_false

    # user goes to index
    current_path.should == super_admin_themes_path
    page.should have_content "My theme"
    page.should have_content "my_theme"
    page.should have_content "Público"
    page.should_not have_content "description"
    page.should_not have_content @company1.name
    page.should_not have_content @company2.name

    click_link "My theme"

    # user goes to edit page
    within "form.edit_theme" do
      find("input#theme_name").value.should           == "My theme"
      find("textarea#theme_description").value.should == "description"
      find("input#theme_path").value.should           == "my_theme"

      fill_in "theme_name",        with: "My theme2"
      fill_in "theme_description", with: "description"
      fill_in "theme_path",        with: "my_theme2"
      uncheck "theme_public"
      select @company2.name,       from: "theme_company_id"
      click_button "commit"
    end

    # user goes to index
    current_path.should == super_admin_themes_path
    page.should have_content "My theme2"
    page.should have_content "my_theme2"
    page.should have_content "Tema privado"
    page.should have_content @company2.name
    page.should_not have_content @company1.name
    page.should_not have_content "description"

    theme.reload
    theme.company.should == @company2
    theme.vertical_taxonomy_menu.should be_true
  end
end
