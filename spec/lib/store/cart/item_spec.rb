require "unit_spec_helper"
require "store/cart/item"

describe Store::Cart::Item do
  let(:product) do
    double(id: 2,
           title: "The Tick",
           description: "A movie",
           price: "10.10")
  end

  it_obeys_the "cart item contract"

  describe "the item's properties" do
    let(:item) { Store::Cart::Item.new(product) }

    it "returns the product id" do
      item.id.should == 2
    end

    it "returns the product title" do
      item.title.should == "The Tick"
    end

    it "returns the product description" do
      item.description.should == "A movie"
    end

    it "returns the product price" do
      item.price.should == "10.10"
    end
  end
end
