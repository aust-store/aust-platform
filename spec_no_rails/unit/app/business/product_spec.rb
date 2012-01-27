require "./spec_no_rails/spec_helper"

describe Product do
  before do
    @product_in = [double("ProductIn", id: 1, cost: 300), double("ProductIn", id: 2, cost: 500)]
    @product = double("Product", id: 1)
    @product.stub(:entries).and_return(@product_in)
  end

  it "" do
    puts @product.entries.first.cost.inspect
  end

end