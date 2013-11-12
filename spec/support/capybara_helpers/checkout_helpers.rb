module CapybaraHelpers
  module CheckoutHelpers
    def add_item_to_cart(entry)
      visit product_path(entry)
      click_link "add_to_cart"
    end

    def select_zipcode_in_the_cart(zipcode = "96360000")
      within(".js_service_selection") { choose("type_pac") }
      fill_in "zipcode", with: zipcode
      click_button "update_cart"
    end

    def click_checkout_in_the_cart
      click_on "checkout_button"
    end

    def customer_signs_in_during_checkout
      @customer ||= FactoryGirl.create(:customer, store: @company)
      page.should have_content "Login"
      fill_in "customer_email", with: @customer.email
      fill_in "customer_password", with: "123456"
      click_on "sign_in"
      current_path.should == checkout_shipping_path
    end
  end
end
