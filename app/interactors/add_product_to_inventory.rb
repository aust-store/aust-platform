class AddProductToInventory
  attr_reader :product, :inventory

  def initialize(product, inventory)
    @product, @inventory = product, inventory
  end

  def call
    @inventory.add(@product).persist
  end
end