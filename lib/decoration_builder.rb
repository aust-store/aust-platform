class DecorationBuilder
  def self.inventory_items(item)
    Admin::InventoryItemDecorator.decorate(item)
  end

  def self.inventory_entries(entries)
    Admin::InventoryEntryDecorator.decorate(entries)
  end

  def self.shipping_box(shipping_box)
    Admin::ShippingBoxDecorator.decorate(shipping_box)
  end

  def self.cart(cart)
    Store::CartDecorator.decorate(cart)
  end
end
