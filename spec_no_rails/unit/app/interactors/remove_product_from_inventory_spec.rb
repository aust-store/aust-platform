require "./spec_no_rails/spec_helper"

describe RemoveProductFromInventory do
  before do
    @product = { id: 1, cost: 300.0 }
    @inventory = double("Inventory")
    @inventory.stub(:remove).and_return(true)
  end

  it "instantiates with product and inventory" do
    result = RemoveProductFromInventory.new([1, 2], [])
    [result.product, result.inventory].should == [[1, 2], []]
  end

  it "tell inventory to remove product" do
    @inventory.should_receive(:remove)
    RemoveProductFromInventory.new(@product, @inventory).call
  end
end