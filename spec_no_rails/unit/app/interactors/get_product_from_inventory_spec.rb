require "./spec_no_rails/spec_helper"

describe GetProductFromInventory do
  before do
    @product = { id: 1, name: "John Doe" }
    @inventory = double("Inventory")
    @inventory.stub(:add).and_return(@inventory)
    @inventory.stub(:persist).and_return(true)

  end

  it "instantiates with product, inventory" do
    result = GetProductFromInventory.new([1, 2], [1, 2] )
    [result.product, result.inventory].should == [[1, 2], [1, 2]]
  end
end
