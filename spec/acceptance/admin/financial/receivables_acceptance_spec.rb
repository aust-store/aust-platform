# coding: utf-8
require 'acceptance_spec_helper'

feature "Receivables management" do
  before do
    login_into_admin
    @customer = FactoryGirl.create(:customer)
  end

  describe "As an admin, adding a new account receivable" do
    context "through the user profile" do
      before do
        visit admin_customer_path(@customer)
        click_link "Nova dívida"
        fill_in "Descrição", with: "Description about the receivable"
      end

      context "valid form" do
        scenario "I'd like to add new customers" do
          fill_in "Valor", with: "R$ 123,45"
          fill_in "Data", with: "16/04/2016"
          click_button "Salvar conta a receber"

          page.should have_content("R$ 123,45")
          page.should have_content("Description about the receivable")
        end
      end

      context "different values for the 'value' field" do
        before do
          fill_in "Data", with: "16/04/2016"
        end

        scenario "I leave the 'value' field blank" do
          click_button "Salvar conta a receber"

          current_path.should == admin_customer_account_receivables_path(@customer)
          page.should have_content("Valor deve ter um valor válido")
        end

        scenario "format value field properly if I leave the form blank" do
          fill_in "Valor", with: "R$ 0"
          click_button "Salvar conta a receber"

          current_path.should == admin_customer_account_receivables_path(@customer)
          find("#account_receivable_value")[:value].should == "R$ 0,00"
        end
      end
    end
  end

  describe "Editing an existing account receivable" do
    before do
      @account_receivable = FactoryGirl.create(:account_receivable)
      visit admin_customer_path(@customer)
      click_link "Contas a receber"
      click_link "R$ 500,00"
    end

    scenario "I'd like to change all fields values" do
      fill_in "Valor", with: "R$ 123,45"
      fill_in "Data", with: "16/04/2016"
      fill_in "Descrição", with: "Simple description"
      click_button "Salvar conta a receber"

      page.should have_content("R$ 123,45")
      page.should have_content("16/04")
      page.should have_content("Simple description")
    end
  end

  describe "Deleting an account receivable" do
    before do
      @account_receivable = FactoryGirl.create(:account_receivable)
      visit admin_customer_path(@customer)
      click_link "Contas a receber"
    end

    scenario "I'd like to change all fields values" do
      page.should have_content("R$ 500,00")
      find(".delete_account_receivable").click
      page.should_not have_content("R$ 500,00")
    end
  end
end
