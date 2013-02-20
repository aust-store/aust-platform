class InventoryItemPrice < ActiveRecord::Base
  attr_accessible :inventory_item_id, :value

  belongs_to :item, class_name: "InventoryItem"
end
