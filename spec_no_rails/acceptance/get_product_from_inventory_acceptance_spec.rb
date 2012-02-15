require "./spec_no_rails/spec_helper"

describe "get product from inventory acceptance test" do
  before do
    @product_persistence = double("ProductPersistence", persist: true)
    @product = Product.new(id: 1)
    @product.stub(:persistence_layer).and_return(@product_persistence)
    @inventory_persistence = double("InventoryPersistence", persist: true)
    @inventory_persistence.stub(:all).and_return([1, 2, 3])
    @inventory_persistence.stub(:last).and_return(3)

    @inventory = Inventory.new(id: 1)
    @inventory.stub(:persistence_layer).and_return(@inventory_persistence)
  end

  context "retrieving from persistence" do
    before do
      @inventory.should_receive(:persistence_layer)
    end
    
    it "get product from inventory" do
      GetProductFromInventory.new(@inventory, @product).all.should == [1, 2, 3]
    end

    it "get last added product" do
      GetProductFromInventory.new(@inventory, @product).last.should == 3
    end
  end
end
