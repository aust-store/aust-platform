class Admin::InventoryEntryDecorator < ApplicationDecorator
  decorates :inventory_entry
  allows :description
  allows :quantity, :cost_per_unit, :total_quantity, :total_cost
  allows :created_at

  include ::ActionView::Helpers::NumberHelper

  def cost_per_unit
    to_currency inventory_entry.cost_per_unit
  end

  def total_cost
    to_currency inventory_entry.total_cost
  end

  def created_at
    inventory_entry.created_at.strftime("%d/%m/%Y")
  end

  private

  def to_currency(value)
    number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end
end
