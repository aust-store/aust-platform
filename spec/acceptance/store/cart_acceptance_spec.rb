# encoding: utf-8
require "acceptance_spec_helper"

feature "Store cart" do
  before do
    @company = FactoryGirl.create(:company)
  end

  describe "an empty cart" do
    scenario "As an user, I can see an appropriate message" do
      visit store_cart_path(@company.handle)

      page.should have_content "Seu carrinho está vazio."
    end
  end
end
