class DecorationBuilder
  def self.inventory_items(resources)
    decorate(Admin::InventoryItemDecorator, resources)
  end

  def self.inventory_entries(resources)
    decorate(Admin::InventoryEntryDecorator, resources)
  end

  def self.shipping_box(resources)
    decorate(Admin::ShippingBoxDecorator, resources)
  end

  def self.cart(resources)
    decorate(Store::CartDecorator, resources)
  end

  private

  def self.decorate(decorator, resource)
    if resource.respond_to?(:each)
      decorator.decorate_collection(resource)
    else
      decorator.decorate(resource)
    end
  end
end
