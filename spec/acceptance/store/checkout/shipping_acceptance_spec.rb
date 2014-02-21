# encoding: utf-8
require "acceptance_spec_helper"

feature "Store cart" do
  before do
    stub_correios
    @company = create(:company_with_zipcode)
    stub_subdomain(@company)
    @product = create(:inventory_item, company: @company)

    # bypass the gateway step, leading the customer directly from the
    # "finish order" to the success page
    stub_payment_gateway
  end

  describe "shipping address changes" do
    let(:inventory_entry) { @product.balances.first }

    before do
      stub_shipping(total: 111.23)
      add_item_to_cart(@product)
    end

    scenario "As a customer, I'm notified that my shipping address' zipcode doesn't " + \
             "match the one I entered in the cart" do
      stub_shipping(zipcode: "00000000")
      select_zipcode_in_the_cart
      OrderShipping.count.should == 1
      OrderShipping.first.price.should == 111.23

      click_checkout_in_the_cart
      customer_signs_in_during_checkout

      # shipping address selection page
      page.should have_content I18n.t("store.checkout.shipping.show.notices.zipcode_doesnt_match")
      stub_shipping(total: 222)

      click_on "place_order_with_default_address"

      # the shipping cost is recalculated and then the customer is sent to the payment gateway
      OrderShipping.count.should == 1
      OrderShipping.first.price.should == 222
    end

    scenario "As a customer, I'm not notified if zipcode from cart and address matches" do
      select_zipcode_in_the_cart
      OrderShipping.count.should == 1
      OrderShipping.first.price.should == 111.23

      click_checkout_in_the_cart
      customer_signs_in_during_checkout

      # shipping address selection page
      page.should_not have_content I18n.t("store.checkout.shipping.show.notices.zipcode_doesnt_match")

      # the shipping cost is not recalculated
      OrderShipping.first.price.should == 111.23
    end
  end
end
