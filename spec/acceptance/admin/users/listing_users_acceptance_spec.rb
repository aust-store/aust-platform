# encoding: utf-8
require 'acceptance_spec_helper'

feature "Users listing" do

  context "founders managing users accounts" do
    before do
      login_into_admin
      @user = FactoryGirl.create(:admin_user, name: "arekufun",
                                 company:           @admin_user.company,
                                 role:              "collaborator")
    end

    scenario "As a founder, I can edit users" do
      click_link "Colaboradores"
      click_link "arekufun"
      current_path.should == edit_admin_user_path(@user)
    end

    scenario "As a founder, I can erase users" do
      click_link "Colaboradores"
      click_link "Excluir usuário #{@user.name}"
    end
  end

  context "founders managing their own account" do
    before do
      login_into_admin
    end

    scenario "As a founder, I cannot erase me" do
      click_link "Colaboradores"
      page.should_not have_content "Excluir usuário #{@admin_user.name}"
    end

    scenario "As a founder, I will be redirected when trying to erase myself" do
      visit admin_users_path(id: @admin_user, method: :delete)
      current_path.should_not == admin_users_path(id: @admin_user, method: :delete)
      current_path.should == admin_users_path
    end

    scenario "As a founder, I can edit me" do
      click_link "Colaboradores"
      click_link "The Tick"
      current_path.should == edit_admin_user_path(@admin_user)
    end
  end

  context "Users managing their own account" do
    before do
      @admin_user = FactoryGirl.create(:admin_user, id: 3, name: "Silviom", role: "collaborator")
      login_into_admin
    end

    scenario "As a collaborator, I cannot erase me" do
      click_link "Colaboradores"
      page.should_not have_content "Excluir usuário #{@admin_user.name}"
    end
    
    scenario "As a collaborator, I will be redirected when trying to erase myself" do
      visit admin_users_path(id: 3, method: :delete)
      current_path.should_not == admin_users_path(id: 3, method: :delete)
      current_path.should == admin_users_path
    end

    scenario "As a collaborator, I can edit me" do
      click_link "Colaboradores"
      click_link "Silviom"
    end
  end

  context "Users managing other users' account" do
    before do
      @admin_user = FactoryGirl.create(:admin_user, name: "Silviom", role: "collaborator")
      login_into_admin
      @user = FactoryGirl.create(:admin_user,
                                 name:    "arekufun2",
                                 company: @admin_user.company,
                                 role:    "collaborator")
    end

    scenario "As a collaborator I can't create a new user" do
      click_link "Colaboradores"
      page.should_not have_link ("Novo colaborador")
    end

    scenario "As a collaborator, I will be redirected when trying to create other users" do
      visit new_admin_user_path
      current_path.should_not == new_admin_user_path
      current_path.should == admin_users_path
    end

    scenario "As a collaborator, I cannot edit other users" do
      click_link "Colaboradores"
      page.should_not have_link('arekufun2')
    end

    scenario "As a collaborator, I will be redirected when trying to edit other users" do
      visit edit_admin_user_path(@user)
      current_path.should_not == edit_admin_user_path(@user)
      current_path.should == admin_users_path
    end

    scenario "As a collaborator, I cannot erase other users" do
      click_link "Colaboradores"
      page.should_not have_content "Excluir usuário #{@user.name}"
    end

    scenario "As a collaborator, I will be redirected when trying to erase other users" do
      visit admin_users_path(id: 7, method: :delete)
      current_path.should_not == admin_users_path(id: 7, method: :delete)
      current_path.should == admin_users_path
    end
  end
end
