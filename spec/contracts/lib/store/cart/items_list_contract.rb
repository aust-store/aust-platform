require "store/cart/items_list"

shared_examples_for "cart items list contract" do
  it "responds to list" do
    expect do
      Store::Cart::ItemsList.new(double.as_null_object).list
    end.to_not raise_error
  end
end
