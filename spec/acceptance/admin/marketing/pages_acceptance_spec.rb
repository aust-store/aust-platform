# encoding: utf-8
require 'acceptance_spec_helper'

feature "Managing Pages" do
  before do
    login_into_admin
    stub_subdomain(@admin_user.company)
    @user = FactoryGirl.create(:admin_user, name: "arthur",
                               company: @admin_user.company)
  end

  scenario "As an Admin, I create pages" do
    visit admin_marketing_index_path
    click_link "manage_pages"
    click_link "create_page"

    current_path.should == new_admin_page_path
    fill_in "page_title", with: "título da nova página"
    click_button "Salvar"

    current_path.should == admin_pages_path
    page.should have_content "título da nova página"
  end

  scenario "As a Admin, I want to edit a chosen page" do
    mypage = FactoryGirl.create(:page, company: @admin_user.company)
    visit admin_marketing_index_path
    click_link "manage_pages"
    click_link mypage.title

    find("#page_title").value.should == mypage.title
    fill_in "page_title", with: "Página editada"

    click_button "Salvar"

    current_path.should == admin_pages_path
    page.should have_content "Página editada"
  end
end
