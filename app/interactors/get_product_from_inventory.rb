class GetProductFromInventory
  attr_reader :product, :inventory

  def initialize(inventory, product)
    @product, @inventory = product, inventory
  end

  def all
    @inventory.all
  end
end
