require "unit_spec_helper"
require "store/cart/shipping_calculation"

describe Store::Cart::ShippingCalculation do
  it_obeys_the "cart contract"

  let(:params)       { {zipcode: "456", type: :pac} }
  let(:calculation)  { double(calculate: calc_results) }
  let(:calc_results) { double(days: 4, total: 12.0, success?: false) }
  let(:controller) do
    double(cart: double(persisted_cart: :cart),
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
    stub_const("OrderShipping", double)
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
        OrderShipping
          .should_receive(:create_for_cart)
          .with({price: 12.0, delivery_days: 4,
                 delivery_type: :correios, service_type: :pac,
                 zipcode: "456", cart: :cart})
        subject.create
      end

      it "should not save the shipping price if result is not success" do
        calc_results.stub(:success?) { false }
        OrderShipping.should_not_receive(:create_for_cart)
        subject.create
      end
    end
  end
end
