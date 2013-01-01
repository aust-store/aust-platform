# encoding: utf-8
require "acceptance_spec_helper"

feature "Store cart" do
  let(:pagseguro) { double }

  background do
    @company = FactoryGirl.create(:company_with_zipcode)
    @product = FactoryGirl.create(:inventory_item, company: @company)
    @user    = FactoryGirl.create(:user, store: @company)
    stub_subdomain(@company)
    stub_shipping

    # bypass the gateway step, leading the user directly from the
    # "finish order" to the success page
    Store::Payment::Pagseguro::Checkout.stub(:new) { pagseguro }
    pagseguro.stub(:create_transaction)
    pagseguro.stub(:payment_url) { checkout_success_path }
  end

  describe "checkout process" do
    scenario "As a signed out user, I want to checkout", js: true do
      # user adds item to the cart
      visit product_path(@product.balances.first)
      click_link "Adicionar ao carrinho"

      # user defines shipping details
      within(".js_service_selection") { choose("type_pac") }
      fill_in "zipcode", with: "96360000"

      page.should have_content "R$ 12,34"
      page.should have_content "entrega em 3 dias úteis"
      click_on "checkout_button"

      # user signs in
      page.should have_content "Login"
      fill_in "user_email", with: @user.email
      fill_in "user_password", with: "123456"
      click_on "sign_in"

      page.should have_content I18n.t('store.checkout.shipping.show.page_title')

      within(".edit_cart") do
        find("[name='place_order']").click
      end

      cart = Cart.last
      Order.first.cart_id.should == cart.id

      page.should have_content "Sucesso"
    end
  end
end
