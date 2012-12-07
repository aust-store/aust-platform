class OrderItem < ActiveRecord::Base
  belongs_to :inventory_item
  belongs_to :inventory_entry
  has_one :shipping_box

  def name
    inventory_item.name
  end

  def description
    inventory_item.description
  end

  def remaining_entries_in_stock
    inventory_entry.quantity
  end

  def update_quantity(quantity)
    quantity = remaining_entries_in_stock if quantity > remaining_entries_in_stock
    quantity = 0 if quantity < 0
    update_attributes(quantity: quantity)
  end
end
