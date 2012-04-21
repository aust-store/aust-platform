# coding: utf-8
require 'spec_helper'

feature "Receivables management" do
  before do
    login_into_admin
    @customer = FactoryGirl.create(:customer)
  end

  describe "As an admin, adding a new receivable account" do
    context "through the user profile" do
      before do
        visit admin_customer_path(@customer)
        click_link "Nova dívida"
        fill_in "Descrição", with: "Description about the receivable"
      end

      context "valid form" do
        scenario "I'd like to add new customers" do
          fill_in "Valor", with: "R$ 123,45"
          fill_in "Data", with: "16/04/2012"
          click_button "Salvar conta a receber"

          page.should have_content("R$ 123,45")
          page.should have_content("Description about the receivable")
        end
      end

      context "different values for the 'value' field" do
        before do
          fill_in "Data", with: "16/04/2012"
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
end

