class Inventory
  attr_accessor :products

  def initialize(options = {})
    @store_id = options[:store_id]
    @products = []
    self
  end

  def add(product, options = {})
    quantity = options.has_key?(:quantity) ? options[:quantity] : 1
    @products << product
    self
  end

  def remove(product, options = {})
    quantity = options.has_key?(:quantity) ? options[:quantity] : "all"
    persistence_layer.remove(product, quantity: quantity)
  end

  def persist
    persistence_layer.persist self
  end

  def persistence_layer(object = InventoryPersistence)
    object
  end
end