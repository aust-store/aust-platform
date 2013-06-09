require 'spec_helper'

describe Store::Checkout::PaymentController do
  it_should_behave_like "authenticable controller"

  login_user

  let(:sale)     { double(order: :order).as_null_object }
  let(:cart)     { double(persistence: cart_model).as_null_object }
  let(:cart_model) { double(zipcode_mismatch?: false) }
  let(:checkout) { double(payment_url: 'http://payment_url').as_null_object }

  before do
    controller.stub(:cart) { cart }
    Store::Sale.stub(:new).with(cart_model) { sale }
    Store::Payment::Pagseguro::Checkout.stub(:new).with(controller, :order) { checkout }

    cart_model.stub(:shipping) { double(zipcode: 1, service_type: 2) }
  end

  describe "GET show" do
    describe "normal flow" do
      describe "shipping cost recalculation" do
        it "recalculates the shipping cost if there's a zipcode mismatch" do
          cart_model.should_receive(:zipcode_mismatch?) { true }
          ::Store::CartShippingCalculation
            .should_receive(:create)
            .with(controller, {destination_zipcode: 1, type: 2})
          get :show
        end

        it "recalculates the shipping cost if there's a zipcode mismatch" do
          cart_model.should_receive(:zipcode_mismatch?) { false }
          ::Store::CartShippingCalculation.should_not_receive(:create)
          get :show
        end
      end

      it "redirects to the payment gateway" do
        checkout.should_receive(:create_transaction)
        get :show
        response.should redirect_to "http://payment_url"
      end

      it "converts the current cart into an order" do
        sale.should_receive(:close)
        get :show
      end

      it "resets the cart" do
        controller.should_receive(:reset_cart)
        get :show
      end
    end

    describe "when one item has more quantity than we have in stock" do
      before do
        Store::Order::Items::OutOfStockAdjustment.stub_chain(:new, :adjust)
        Store::Sale.stub(:new).and_raise(InventoryEntry::NegativeQuantity)
      end

      it "removes some items from the cart to comply with stock" do
        adjustment = double
        Store::Order::Items::OutOfStockAdjustment
          .stub(:new)
          .and_return(adjustment)

        adjustment.should_receive(:adjust)
        get :show
      end

      it "redirects the user to the cart page" do
        get :show
        response.should redirect_to cart_path
      end

      it "shows the user a message" do
        get :show
        flash.alert.should == I18n.t("store.errors.checkout.entry_with_negative_quantity")
      end
    end
  end

  describe "#after_payment_return_url" do
    it "returns the correct return url for each gateway" do
      controller.after_payment_return_url(:pagseguro).should == checkout_success_url
    end
  end
end
