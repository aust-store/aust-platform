class InventoryItemPrice < ActiveRecord::Base
  attr_accessible :inventory_item_id, :value, :for_installments

  belongs_to :item, class_name: "InventoryItem"

  validates :value, presence: true

  def value=(value)
    self[:value] = ::Store::Currency.to_float(value) if value.present?
  end

  def for_installments=(value)
    self[:for_installments] = ::Store::Currency.to_float(value) if value.present?
  end

  # if no value for installments was defined, we just use the regular price
  def for_installments
    return self.value if self[:for_installments].blank? || self[:for_installments].zero?
    self[:for_installments]
  end
end
