require "store/cart/price_calculation"

shared_examples_for "cart price calculation contract" do
  it "responds to calculate" do
    expect do
      Store::Cart::PriceCalculation.calculate([])
    end.to_not raise_error
  end
end
