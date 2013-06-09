# encoding: utf-8
require "acceptance_spec_helper"

feature "Store cart" do
  before do
    stub_correios
    @company = FactoryGirl.create(:company_with_zipcode)
    stub_subdomain(@company)
    @product = FactoryGirl.create(:inventory_item, company: @company)
  end

  describe "shipping address changes" do
    let(:inventory_entry) { @product.balances.first }

    before do
      stub_shipping
      add_item_to_cart(inventory_entry)
    end

    scenario "As an user, I'm notified that my shipping address' zipcode doesn't " + \
             "match the one I entered in the cart" do
      stub_shipping("00000000")
      select_zipcode_in_the_cart
      click_checkout_in_the_cart
      user_signs_in_during_checkout

      page.should have_content I18n.t("store.checkout.shipping.show.notices.zipcode_doesnt_match")
    end

    scenario "As an user, I'm not notified if zipcode from cart and address matches" do
      select_zipcode_in_the_cart
      click_checkout_in_the_cart
      user_signs_in_during_checkout

      page.should_not have_content I18n.t("store.checkout.shipping.show.notices.zipcode_doesnt_match")
    end
  end
end
