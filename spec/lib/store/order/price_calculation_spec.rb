require "bigdecimal"
require "unit_spec_helper"
require "store/order/price_calculation"

describe Store::Order::PriceCalculation do
  it_obeys_the "order price calculation contract"
  it_obeys_the "cart item contract"

  it "calculates the price of all given items" do
    items = [
      double(price: BigDecimal("10.10")),
      double(price: BigDecimal("11.00")) ]
    described_class.calculate(items).should == BigDecimal("21.10")
  end

  it "returns 0 if no items are given" do
    described_class.calculate([]).should == BigDecimal("0")
  end

  it "must receive a collection of items" do
    described_class.calculate("Jar Jar Binks").should == 0
    described_class.calculate(11.22).should == 0
    described_class.calculate(nil).should == 0
  end
end
