require "spec_helper"
require "bigdecimal"
require "unit_spec_helper"
require "store/order/price_calculation"

describe Store::Order::PriceCalculation do
  it_obeys_the "order price calculation contract"
  it_obeys_the "cart item contract"

  let(:order) { double }
  let(:item1) { double(price: BigDecimal("10.10"),
                       price_for_installments: BigDecimal("51.02")) }
  let(:item2) { double(price: BigDecimal("11.00"),
                       price_for_installments: nil) }
  let(:items) { [item1, item2] }

  subject { described_class.new(order, items) }

  describe "#total" do
    context "order is paid on cash" do
      it "calculates the price of all given items" do
        subject.total(nil).should == BigDecimal("21.10")
      end
    end

    context "order is paid on installments" do
      it "calculates the price of all given items" do
        subject.total("installments").should == BigDecimal("62.02")
      end
    end

    it "returns 0 if no items are given" do
      described_class.new(order, []).total.should == BigDecimal("0")
    end

    it "must receive a collection of items" do
      described_class.new(order, "Jar Jar Binks").total.should == 0
      described_class.new(order, 11.22).total.should == 0
      described_class.new(order, nil).total.should == 0
    end
  end
end
