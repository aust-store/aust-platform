# encoding: utf-8
require 'acceptance_spec_helper'

feature "Dashboard/Setup warnings" do
  let(:company) { create(:barebone_company) }
  let(:user)    { create(:admin_user, company: company) }

  before do
    login_into_admin(as: user)
    stub_subdomain(company)
  end

  describe "the index page" do
    let(:i18n_suffix)      { "admin.setup_messages.missing_" }

    let(:missing_zipcode)  { I18n.t("#{i18n_suffix}zipcode.title") }
    let(:missing_taxonomy) { I18n.t("#{i18n_suffix}taxonomy.title") }
    let(:missing_products) { I18n.t("#{i18n_suffix}products.title") }
    let(:missing_domain)   { I18n.t("#{i18n_suffix}domain.title") }
    let(:missing_payments) { I18n.t("#{i18n_suffix}payments.title") }

    scenario "As a store admin, I want to see warnings for missing zipcode" do
      page.should have_content missing_zipcode
      company.settings = create(:company_setting)
      visit admin_root_path
      page.should_not have_content missing_zipcode
    end

    scenario "As a store admin, I want to see warnings for missing categories" do
      page.should have_content missing_taxonomy
      create(:single_taxonomy, store: company)
      visit admin_root_path
      page.should_not have_content missing_taxonomy
    end

    scenario "As a store admin, I want to see warnings for missing products" do
      page.should have_content missing_products
      create(:inventory_item, company: company)
      visit admin_root_path
      page.should_not have_content missing_products
    end

    scenario "As a store admin, I want to see warnings for missing domain" do
      page.should have_content missing_domain
      company.update_attributes(domain: "petshop.com")
      visit admin_root_path
      page.should_not have_content missing_domain
    end

    scenario "As a store admin, I see warnings for missing payment methods" do
      page.should have_content missing_payments
      company.payment_gateway = create(:payment_gateway)
      visit admin_root_path
      page.should_not have_content missing_payments
    end
  end
end
