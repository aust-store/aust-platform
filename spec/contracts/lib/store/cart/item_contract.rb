require "store/cart/item"

shared_examples_for "cart item contract" do
  it "responds to id" do
    expect do
      Store::Cart::Item.new(double.as_null_object).id
    end.to_not raise_error
  end

  it "responds to price" do
    expect do
      Store::Cart::Item.new(double.as_null_object).price
    end.to_not raise_error
  end
end
