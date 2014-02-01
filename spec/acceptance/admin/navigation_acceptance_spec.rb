# encoding: utf-8
require 'acceptance_spec_helper'

feature "Admin/Navigation links" do
  let(:company) { create(:barebone_company, handle: "acpresentes") }
  let(:user)    { create(:admin_user, company: company) }

  before do
    stub_subdomain(company)
  end

  describe "main navigation menu" do
    before do
      login_into_admin(as: user)
    end

    scenario "As a store admin, I can access the POS" do
      page.should have_content "Ponto de venda"
    end
  end
end
