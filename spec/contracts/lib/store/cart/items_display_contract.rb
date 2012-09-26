require "store/cart/items_display"

shared_examples_for "cart items display contract" do
  it "responds to list" do
    expect do
      Store::Cart::ItemsDisplay.new(double.as_null_object).list
    end.to_not raise_error
  end
end
