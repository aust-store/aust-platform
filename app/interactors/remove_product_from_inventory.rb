class RemoveProductFromInventory
  attr_reader :product, :inventory

  def initialize(product, inventory)
    @product, @inventory = product, inventory
  end

  def call
    @inventory.remove(@product)
  end
end