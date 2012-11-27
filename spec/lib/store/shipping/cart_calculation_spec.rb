require "unit_spec_helper"
require "store/shipping/cart_calculation"
require "store/shipping/calculation"

describe Store::Shipping::CartCalculation do
  it_obeys_the "cart contract"

  let(:controller)  { double(cart: double(persisted_cart: :cart)) }
  let(:calculation) { double }
  let(:calc_results) { double(days: 4, total: 12.0) }

  before do
    stub_const("OrderShipping", double)
  end

  describe "#create" do
    it "returns an instance of the result wrapper" do
      result = described_class.new(controller)

      Store::Shipping::Calculation
        .should_receive(:new)
        .with(controller, :br)
        .and_return(calculation)

      calculation
        .should_receive(:calculate)
        .with("456", :pac)
        .and_return(calc_results)

      OrderShipping
        .should_receive(:create)
        .with({price: 12.0, delivery_days: 4,
               delivery_type: :correios, service_type: :pac,
               cart: :cart})

      result.create("456", :pac).should == calc_results
    end
  end
end
