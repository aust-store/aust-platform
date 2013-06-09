require 'spec_helper'

describe Store::Cart::ShippingCostController do
  it_obeys_the "cart contract"

  let(:cart) { double.as_null_object }

  before do
    controller.stub(:cart) { cart }
    controller.stub(:current_user) { :current_user }
    controller.stub(:current_store) { double.as_null_object }
  end

  describe "POST create" do
    it "responds to items" do
      Store::CartShippingCalculation.should_receive(:create) { double.as_null_object }
      post :create, store_id: "my_store", zipcode: "123456", type: :pac
    end
  end
end
