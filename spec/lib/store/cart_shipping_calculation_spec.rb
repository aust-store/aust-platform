require "unit_spec_helper"
require "store/cart_shipping_calculation"

describe Store::CartShippingCalculation do
  it_obeys_the "cart contract"

  let(:params)       { {zipcode: "456", type: :pac} }
  let(:calculation)  { double(calculate: calc_results) }
  let(:cart)         { double }
  let(:calc_results) do
    double(days: 4,
           total: 12.0,
           success?: false,
           width:    :width,
           length:   :length,
           height:   :height,
           weight:   :weight)
  end
  let(:controller) do
    double(cart: double(persisted_cart: cart),
           cart_items_dimensions: :items,
           current_store: double(zipcode: "123"),
           params: params)
  end
  let(:options) do
    { source_zipcode:      "123",
      destination_zipcode: "456",
      items:               :items,
      shipping_type:       :pac,
      country:             "BR" }
  end

  subject { result = described_class.new(controller) }

  before do
    stub_const("Store::Logistics::Shipping::Calculation", Class.new)
  end

  describe "#create" do
    before do
      Store::Logistics::Shipping::Calculation
        .stub(:new)
        .with(options)
        .and_return(calculation)
    end

    it "returns an instance of the result wrapper" do
      calculation.should_receive(:calculate) { calc_results }
      subject.create.should == calc_results
    end

    describe "result persistence" do
      it "should save the shipping price if result is successful" do
        calc_results.stub(:success?) { true }
        cart.should_receive(:update_shipping).with(calc_results)
        subject.create
      end

      it "should not save the shipping price if result is not success" do
        calc_results.stub(:success?) { false }
        cart.should_not_receive(:update_shipping)
        subject.create
      end
    end
  end
end
