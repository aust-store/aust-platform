class Cart < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  has_many :items, class_name: "OrderItem", dependent: :destroy

  def add_item(inventory_entry_id, quantity)
    entry = InventoryEntry.find(inventory_entry_id)
    item = OrderItem.new(
      price: entry.price,
      quantity: quantity,
      inventory_entry: entry,
      inventory_item: entry.good
    )

    items << item
    save
  end
end
