# encoding: utf-8
require "acceptance_spec_helper"

feature "Normal checkout", js: true do
  let(:pagseguro) { double }

  background do
    @company = FactoryGirl.create(:company_with_zipcode)
    @product = FactoryGirl.create(:inventory_item, company: @company)
    @user    = FactoryGirl.create(:user, store: @company)
    stub_subdomain(@company)
    stub_shipping

    # bypass the gateway step, leading the user directly from the
    # "finish order" to the success page
    ::PagSeguro::Payment.any_instance.stub(:checkout_payment_url) { checkout_success_path }
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
        click_link "Adicionar ao carrinho"
      end

      user_defines_shipping_details
      click_on "checkout_button"

      user_signs_in

      page.should have_content I18n.t('store.checkout.shipping.show.page_title')

      # Final button before user goes to PagSeguro
      within(".edit_cart") do
        find("[name='place_order']").click
      end

      # given we flush the cart after the checkout, a new one is generated
      ::Cart.count.should == 2
      cart = Cart.first
      Order.first.cart_id.should == cart.id

      page.should have_content "Sucesso"

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

    scenario "As an user, I'm redirected to the cart if an item is out of stock" do
      @product.entries.second.destroy
      @product.entries.last.destroy

      4.times do
        # user adds item to the cart
        visit product_path(@entry_for_purchase)
        click_link "Adicionar ao carrinho"
      end

      order_item_id = OrderItem.parent_items.first.id
      find("[name='cart[item_quantities][#{order_item_id}]']").value.should == "4"
      user_defines_shipping_details
      click_on "checkout_button"

      user_signs_in

      page.should have_content I18n.t('store.checkout.shipping.show.page_title')

      @entry_for_purchase.update_attributes(quantity: 2)

      # Final button before user goes to PagSeguro
      within(".edit_cart") do
        find("[name='place_order']").click
      end

      current_path.should == cart_path

      find("[name='cart[item_quantities][#{order_item_id}]']").value.should == "2"

      # we check the current state of the inventory/stock
      @product.entries.reload
      @product.entries.first.quantity.should  == 2 # 2 items left this lot
    end
  end

  def user_defines_shipping_details
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
end
