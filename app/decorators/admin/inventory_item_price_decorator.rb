module Admin
  class InventoryItemPriceDecorator < ApplicationDecorator
    decorates :inventory_item_price

    include ::ActionView::Helpers::NumberHelper
    include ::ActionView::Helpers::OutputSafetyHelper

    def value
      to_currency object.value
    end

    private

    def to_currency(value)
      number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
    end
  end
end
