# coding: utf-8
require 'spec_helper'

feature "Receivables management" do
  before do
    login_into_admin
    @user = FactoryGirl.create(:customer)
  end

  describe "Adding a new receivable account" do
    context "through the user profile" do
      scenario "As a admin, I'd like to add new customers" do
        visit admin_customer_path(@user)
        click_link "Nova dívida"
        fill_in "Descrição",with: "Description about the receivable"
        fill_in "Valor", with: "R$ 123,45"
        fill_in "Data", with: "16/04/2036"
        click_button "Salvar"

        page.should have_content("R$ 123,45")
        page.should have_content("Description about the receivable")
      end
    end
  end
end

