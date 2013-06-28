module Store
  class InventoryItemDecorator < ApplicationDecorator
    decorates :inventory_item
    decorates_association :balances, with: Admin::InventoryEntryDecorator

    include ::ActionView::Helpers::NumberHelper

    def images
      model.images
    end

    def price
      to_currency(model.price)
    end

    private

    def to_currency(value)
      number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
    end
  end
end
