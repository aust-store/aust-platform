class InventoryItemPrice < ActiveRecord::Base
  attr_accessible :inventory_item_id, :value

  belongs_to :item, class_name: "InventoryItem"

  validates :value, presence: true

  def value=(value)
    self[:value] = ::Store::Currency.to_float(value) if value.present?
  end
end
