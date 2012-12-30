# encoding: utf-8
require 'acceptance_spec_helper'

feature "PagSeguro as Payment Gateway" do
  before do
    @admin_user = FactoryGirl.create(:admin_user)
    login_into_admin
  end

  scenario "As a store admin, I want to configure PagSeguro" do
    @admin_user.company.payment_gateway.delete
    visit admin_settings_path

    click_link "Configurar meios de pagamento"
    within ".pagseguro" do
      within ".status" do
        page.should have_content "Desativado"
      end

      click_link "configure_pagseguro"
    end

    fill_in "payment_gateway_email", with: "user@example.com"
    click_button "Salvar e prosseguir"
    fill_in "payment_gateway_token", with: "1234567812345678"
    click_button "Salvar e prosseguir"

    visit admin_settings_payment_methods_path
    within ".pagseguro .status" do
      page.should have_content "Ativado"
    end
  end
end
