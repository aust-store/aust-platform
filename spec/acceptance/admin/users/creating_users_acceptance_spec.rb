# encoding: utf-8
require 'acceptance_spec_helper'

feature "Managing collaborators" do
  before do
    login_into_admin
    stub_subdomain(@admin_user.company)
    @user = FactoryGirl.create(:admin_user, name: "oko",
                               company: @admin_user.company,
                               role: "collaborator")
    click_link "settings_link"
    click_link "manage_admin_users"
  end

  context "Inexistent users as collaborators" do
    scenario "As a founder, I'd like to create a new user as a collaborator" do
      click_link "Adicionar usuário"

      page.should have_selector "input#admin_user_name"
      page.should have_selector "input#admin_user_email"
      page.should have_selector "input#admin_user_password"
      page.should have_selector "input#admin_user_password_confirmation"

      fill_in "admin_user_name", with: "Collaborator"
      fill_in "admin_user_email", with: "collaborator@example.com"
      fill_in "admin_user_password", with: "123456"
      fill_in "admin_user_password_confirmation", with: "123456"
      select "Ponto de venda", from: "admin_user_role"

      click_button "Salvar"

      current_path.should == admin_users_path

      user = AdminUser.find_by_email("collaborator@example.com")
      user.name.should == "Collaborator"
      user.role.should == "point_of_sale"
      user.company_id.should == @admin_user.company_id
    end
  end

  context "Existent collaborators" do
    scenario "As an founder, I want to delete a chosen user" do
      page.should have_content "oko"

      click_link "Excluir usuário #{@user.name}"
      current_path.should == admin_users_path
      page.should_not have_content "oko"
    end

    scenario "As a founder, I want to fully edit a chosen user" do
      click_link "oko"

      page.should have_selector "input#admin_user_name"
      page.should have_selector "input#admin_user_email"
      page.should have_selector "input#admin_user_password"
      page.should have_selector "input#admin_user_password_confirmation"

      fill_in "admin_user_name", with: "okosuta"
      fill_in "admin_user_email", with: "okosuta@example.com"
      fill_in "admin_user_password", with: "1234567"
      fill_in "admin_user_password_confirmation", with: "1234567"

      click_button "Salvar"

      current_path.should == admin_users_path

      user = AdminUser.find_by_email("okosuta@example.com")
      user.name.should == "okosuta"
      user.role.should == "collaborator"
      user.company_id.should == @admin_user.company_id
    end

    scenario "As a founder, I want to partially edit a chosen user" do
      click_link "oko"

      page.should have_selector "input#admin_user_name"
      page.should have_selector "input#admin_user_email"
      page.should have_selector "input#admin_user_password"
      page.should have_selector "input#admin_user_password_confirmation"

      fill_in "admin_user_name", with: "okosuta"
      fill_in "admin_user_email", with: "okosuta@example.com"

      click_button "Salvar"

      current_path.should == admin_users_path

      click_link "Sair"

      @admin_user = AdminUser.find_by_email("okosuta@example.com")
      login_into_admin

      @admin_user.name.should == "okosuta"
      @admin_user.role.should == "collaborator"
    end

    scenario "As a founder, I want to edit myself" do
      click_link "The Tick"

      page.should have_selector "input#admin_user_name"
      page.should have_selector "input#admin_user_email"
      page.should have_selector "input#admin_user_password"
      page.should have_selector "input#admin_user_password_confirmation"

      fill_in "admin_user_name", with: "Ezekiel"
      fill_in "admin_user_email", with: "ezekiel@example.com"
      fill_in "admin_user_password", with: "12345678"
      fill_in "admin_user_password_confirmation", with: "12345678"

      click_button "Salvar"

      current_path.should == admin_users_path

      user = AdminUser.find_by_email("ezekiel@example.com")
      user.name.should == "Ezekiel"
      user.role.should == "founder"
      user.company_id.should == @admin_user.company_id
    end
  end

  describe "different subscription plans" do
    scenario "As a founder, I can't see POS option if I don't pay for it" do
      Store::Policy::PointOfSale.stub_chain(:new, :enabled?) { false }

      click_link "Adicionar usuário"
      page.should have_select "admin_user_role", options: ["Colaborador"]
    end
  end
end
