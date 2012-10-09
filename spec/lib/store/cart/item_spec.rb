require "unit_spec_helper"
require "store/cart/item"

describe Store::Cart::Item do
  let(:product) do
    double(id: 2,
           name: "The Tick",
           description: "A movie",
           quantity: 2.0,
           price: "10.10")
  end

  it_obeys_the "cart item contract"

  describe "#quantity" do
    let(:item) { Store::Cart::Item.new(product) }

    it "can be read" do
      item.quantity.should == 2
    end
  end

  describe "the item's properties" do
    let(:item) { Store::Cart::Item.new(product) }

    it "returns the product id" do
      item.id.should == 2
    end

    it "returns the product name" do
      item.name.should == "The Tick"
    end

    it "returns the product description" do
      item.description.should == "A movie"
    end

    it "returns the product price" do
      item.price.should == "10.10"
    end
  end
end
