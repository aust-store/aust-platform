require "store/order/price_calculation"

shared_examples_for "order price calculation contract" do
  it "responds to calculate" do
    expect do
      Store::Order::PriceCalculation.calculate([])
    end.to_not raise_error
  end
end
