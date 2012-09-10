require 'unit_spec_helper'

class Product; end
class Store::ApplicationController; end

require "controllers/store/products_controller"

describe Store::ProductsController do
  subject { Store::ProductsController.new }

  describe "#show" do
    it "loads a products by id" do
      subject.stub(:params) { {id: 1} }
      Good.stub(:find).with(1) { :product }
      subject.show.should == :product
    end
  end

  describe "#add_to_cart" do
    let(:cart) { double }

    before do
      subject.stub(:params) { {id: 1} }
      subject.stub(:cart) { cart }
      subject.stub(:store_cart_path) { :cart_path }
      subject.stub(:redirect_to)
    end

    it "adds the product into the cart" do
      Good.stub(:find).with(1) { :product }
      cart.should_receive(:add_item).with(:product)
      subject.add_to_cart
    end

    it "redirects to the cart page" do
      cart.stub(:add_item)
      subject.should_receive(:redirect_to).with(:cart_path)
      subject.add_to_cart
    end
  end
end
