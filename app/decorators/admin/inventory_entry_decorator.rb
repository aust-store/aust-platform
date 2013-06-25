class Admin::InventoryEntryDecorator < ApplicationDecorator
  decorates :inventory_entry
  decorates_association :inventory_item, with: Admin::InventoryItemDecorator

  include ::ActionView::Helpers::NumberHelper

  def cost_per_unit
    to_currency object.cost_per_unit
  end

  def quantity
    quantity = object.quantity
    quantity ? quantity.to_i : nil
  end

  def total_cost
    to_currency object.total_cost
  end

  def created_at
    object.created_at.strftime("%d/%m")
  end

  private

  def to_currency(value)
    number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end
end
