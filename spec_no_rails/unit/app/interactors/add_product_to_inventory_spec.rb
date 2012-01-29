require "./spec_no_rails/spec_helper"

describe AddProductToInventory do
  before do
    @product = { id: 1 }
    @inventory = double("Inventory")
    @inventory.stub(:add).and_return(true)
    @inventory.stub(:persist).and_return(true)
  end

  it "instantiates with product and inventory" do
    result = AddProductToInventory.new([1, 2], [])
    [result.product, result.inventory].should == [[1, 2], []]
  end

  it "adds a product to the inventory" do
    @inventory.should_receive(:add)
    AddProductToInventory.new(@product, @inventory).call
  end

  it "tell inventory to persist data" do
    @inventory.should_receive(:persist)
    AddProductToInventory.new(@product, @inventory).call
  end
end