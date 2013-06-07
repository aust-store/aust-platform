require "active_support/inflector"
require "store/logistics/shipping/calculation"

describe Store::Logistics::Shipping::Calculation do
  let(:processor) { double }
  let(:items)     { double }
  let(:options) do
    { source_zipcode:      "111",
      destination_zipcode: "222",
      items:               items,
      shipping_type:       :normal,
      country:             "BR" }
  end

  subject { described_class.new(options) }

  before do
    stub_const("ShippingCalculation::Correios::Calculation", Class.new)
  end

  describe "#calculate" do
    it "calls the processor for the corresponding country" do
      ShippingCalculation::Correios::Calculation
        .stub(:new)
        .with({source_zipcode: "111",
               destination_zipcode: "222",
               items: items,
               shipping_type: :normal})
        .and_return(processor)

      processor.should_receive(:calculate)
      subject.calculate
    end
  end
end
