class DecorationBuilder
  def self.good(good)
    Admin::GoodDecorator.decorate(good)
  end

  def self.inventory_entries(entries)
    Admin::InventoryEntryDecorator.decorate(entries)
  end
end
