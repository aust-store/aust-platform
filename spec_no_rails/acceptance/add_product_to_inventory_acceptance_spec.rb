require "./spec_no_rails/spec_helper"

describe AddProductToInventory do
  before do
    @inventory_persistence = double("InventoryPersistence", persist: true)
    @product = Product.new(name: 1, cost: 1.5, price: 2.5)
    @inventory = Inventory.new(store_id: 1)
    @inventory.stub(:persistence_layer).and_return(@inventory_persistence)
  end

  it "adds a product to the Inventory" do
    @inventory.should_receive(:persistence_layer)
    AddProductToInventory.new(@product, @inventory).call
  end
end