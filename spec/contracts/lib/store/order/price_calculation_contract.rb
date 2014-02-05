require "store/order/price_calculation"

shared_examples_for "order price calculation contract" do
  subject { Store::Order::PriceCalculation.new(double, double) }

  it "responds to calculate" do
    expect(subject).to respond_to(:total)
  end
end
