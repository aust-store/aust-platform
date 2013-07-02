# encoding: utf-8
require "acceptance_spec_helper"

feature "Normal checkout", js: true do
  background do
    @company = FactoryGirl.create(:company_with_zipcode)
    @product = FactoryGirl.create(:inventory_item, company: @company)
    @user    = FactoryGirl.create(:user, store: @company)
    stub_subdomain(@company)
    stub_shipping

    # bypass the gateway step, leading the user directly from the
    # "finish order" to the success page
    stub_payment_gateway
  end

  describe "checkout process" do
    background do
      # we check the current state of the inventory/stock
      @entries = @product.entries.order('id asc')
      @entries.first.quantity.should  == 8
      @entries.second.quantity.should == 8
      @entries.last.quantity.should   == 8
      @entries.size.should            == 3

      @entry_for_purchase = @entries.first
    end

    scenario "As a signed out user, I want to checkout" do

      2.times do
        # user adds item to the cart
        visit product_path(@entry_for_purchase)
        click_link I18n.t("store.products.show.add_to_cart_link")
      end

      user_defines_cart_shipping_zipcode
      click_on "checkout_button"

      user_signs_in

      page.should have_content I18n.t('store.checkout.shipping.show.page_title')

      # Final button before user goes to PagSeguro
      click_button "place_order_with_default_address"

      # it goes to checkout_payment_url and then to
      current_path.should == checkout_success_path

      # given we flush the cart after the checkout, a new one is generated
      ::Cart.count.should == 2
      cart = Cart.first
      order = Order.first
      order.cart_id.should == cart.id

      page.should have_content "Sucesso"

      assert_address(order.shipping_address, @user.default_address)

      # we check the current state of the inventory/stock
      @entries.reload
      @entries.first.quantity.should  == 6 # 2 items left this lot
      @entries.second.quantity.should == 8
      @entries.last.quantity.should   == 8
      @entries.size.should            == 3


      # checks if the cart has been really flushed
      visit cart_path
      page.should_not have_content "R$ 12,34"
    end

    describe "variances" do
      scenario "As an user, I checkout defining a custom shipping address" do
        # user adds item to the cart
        visit product_path(@entry_for_purchase)
        click_link I18n.t("store.products.show.add_to_cart_link")

        user_defines_cart_shipping_zipcode
        click_on "checkout_button"

        user_signs_in

        page.should have_content I18n.t('store.checkout.shipping.show.page_title')

        prefix = "cart_shipping_address_attributes"
        fill_in "#{prefix}_address_1",    with: "300 E Street SW"
        fill_in "#{prefix}_address_2",    with: "x"
        fill_in "#{prefix}_number",       with: "123"
        fill_in "#{prefix}_neighborhood", with: "Center"
        fill_in "#{prefix}_zipcode",      with: "20024-321"
        fill_in "#{prefix}_city",         with: "Washington DC"
        fill_in "#{prefix}_state",        with: "RS"

        # Final button before user goes to PagSeguro
        click_button "place_order_with_custom_shipping_address"

        # given we flush the cart after the checkout, a new one is generated
        ::Cart.count.should == 2
        cart = Cart.first
        order = Order.first
        order.cart_id.should == cart.id

        page.should have_content "Sucesso"

        order_address = Address.last
        order_address.address_1.should == "300 E Street SW"
        order_address.address_2.should == "x"
        order_address.number.should == "123"
        order_address.neighborhood.should == "Center"
        order_address.zipcode.should == "20024-321"
        order_address.city.should == "Washington DC"
        order_address.state.should == "RS"
        order_address.country.should == "BR"
        order_address.addressable.should == order
      end

      scenario "As an user, I'm redirected to the cart if an item is out of stock" do
        @product.entries.second.destroy
        @product.entries.last.destroy

        @product.entries.count.should == 1
        @product.entries.first.quantity.should > 3
        3.times do
          # user adds item to the cart
          visit root_path
          click_link "product_show_page_#{@product.id}"
          click_link "add_to_cart"
        end

        order_item_id = OrderItem.parent_items.first.id
        # cart quantity field
        find("[name='cart[item_quantities][#{order_item_id}]']").value.should == "3"
        user_defines_cart_shipping_zipcode
        click_on "checkout_button"

        user_signs_in

        page.should have_content I18n.t('store.checkout.shipping.show.page_title')

        @product.entries.first.update_attributes(quantity: 2)

        # Final button before user goes to PagSeguro
        click_button "place_order_with_default_address"

        current_path.should == cart_path

        find("[name='cart[item_quantities][#{order_item_id}]']").value.should == "2"

        # we check the current state of the inventory/stock
        @product.entries.reload
        @product.entries.first.quantity.should  == 2 # 2 items left this lot
      end
    end
  end

  def user_defines_cart_shipping_zipcode
    within(".js_service_selection") { choose("type_pac") }
    fill_in "zipcode", with: "96360000"

    page.should have_content "R$ 12,34"
    page.should have_content "entrega em 3 dias úteis"
  end

  def user_signs_in
    page.should have_content "Login"
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: "123456"
    click_on "sign_in"
  end

  def assert_address(address1, address2)
    address1.address_1.should == address2.address_1
    address1.address_2.should == address2.address_2
    address1.city.should      == address2.city
    address1.zipcode.should   == address2.zipcode
    address1.country.should   == address2.country
  end
end
