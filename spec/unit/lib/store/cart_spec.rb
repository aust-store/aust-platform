module Store; class Cart; class PriceCalculation; end; end; end
require "unit_spec_helper"
require "store/cart"

describe Store::Cart do
  let(:item) { double(id: 1) }
  subject { Store::Cart.new }

  it_obeys_the "cart item contract"
  it_obeys_the "cart price calculation contract"

  describe "adding items" do
    it "adds one item to the cart" do
      subject.add_item(item)
      subject.items.should include item
    end

    it "adds five items to the cart" do
      subject.add_item(item, 4)
      subject.items.should == [item, item, item, item]
    end

    it "tests the add_item implementation" do
      subject.add_item(item, 4)
      subject.items.should == [item, item, item, item]
    end

    it "should not add zero items to the cart" do
      subject.add_item(item, 0)
      subject.items.should == []
    end

    it "should not add negative items to the cart" do
      subject.add_item(item, -2)
      subject.items.should == []
    end
  end

  describe "retrieving an item quantity" do
    it "returns different quantities for different items" do
      5.times { subject.add_item(item) }
      item_two = double(id: 2)
      subject.add_item(item_two)
      subject.item_quantity(item).should == 5
      subject.item_quantity(item_two).should == 1
    end

    it "returns 0 when a cart doesn't have a given item" do
      subject.item_quantity(double).should == 0
    end
  end

  describe "removing items" do
    it "removes a given item" do
      subject.add_item(item, 5)
      subject.remove_item(item)
      subject.items.should == []
    end
  end

  describe "#total_price" do
    it "delegates the responsibility to price calculation" do
      item_one = double
      item_two = double
      subject.add_item(item_one)
      subject.add_item(item_two)
      Store::Cart::PriceCalculation.stub(:calculate)
                                   .with([item_one, item_two])
                                   .and_return(:total)
      subject.total_price.should == :total
    end
  end

  pending "#total_price_by_item" do

  end
end
