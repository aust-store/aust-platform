class DecorationBuilder
  def self.inventory_items(item)
    Admin::InventoryItemDecorator.decorate(item)
  end

  def self.inventory_entries(entries)
    Admin::InventoryEntryDecorator.decorate(entries)
  end
end
