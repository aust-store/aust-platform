module Admin
  class InventoryItemDecorator < ApplicationDecorator
    decorates :inventory_item
    decorates_association :shipping_box, with: Admin::ShippingBoxDecorator
    decorates_association :prices, with: Admin::InventoryItemPriceDecorator
    decorates_association :entries, with: Admin::InventoryEntryDecorator

    include ::ActionView::Helpers::NumberHelper
    include ::ActionView::Helpers::OutputSafetyHelper

    def name
      [object.manufacturer.try(:name), object.name].join(" ")
    end

    def description
      raw object.description.gsub("\n", "<br />")
    end

    def has_image?
      object.images.present?
    end

    def total_quantity
      object.total_quantity.to_i
    end

    def total_quantity_summing_inventory_entries
      total = total_quantity.to_i
      if total > 0
        "#{total} un."
      else
        "fora do estoque"
      end
    end

    def price
      to_currency object.price
    end

    private

    def to_currency(value)
      number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
    end
  end
end
