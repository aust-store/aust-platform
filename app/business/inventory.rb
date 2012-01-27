class Inventory
  attr_accessor :products

  def initialize
    @products = []
  end

  def add(product, options = {})
    quantity = options.has_key?(:quantity) ? options[:quantity] : 1
    persistence_layer.add(product, quantity: quantity)
  end

  def remove(product, options = {})
    quantity = options.has_key?(:quantity) ? options[:quantity] : "all"
    persistence_layer.add(product, quantity: quantity)
  end

  def persistence_layer(object = InventoryPersistence)
    object
  end
end