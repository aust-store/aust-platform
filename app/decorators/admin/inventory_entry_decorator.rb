class Admin::InventoryEntryDecorator < ApplicationDecorator
  decorates :inventory_entry
  decorates_association :inventory_item, with: Admin::InventoryItemDecorator

  include ::ActionView::Helpers::NumberHelper

  def cost_per_unit
    to_currency inventory_entry.cost_per_unit
  end

  def quantity
    inventory_entry.quantity.to_i
  end

  def price
    to_currency inventory_entry.price
  end

  def total_cost
    to_currency inventory_entry.total_cost
  end

  def created_at
    inventory_entry.created_at.strftime("%d/%m")
  end

  private

  def to_currency(value)
    number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end
end
