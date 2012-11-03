module Store
  class InventoryItemDecorator < ApplicationDecorator
    decorates :good
    decorates_association :balances, with: Admin::InventoryEntryDecorator

    include ::ActionView::Helpers::NumberHelper

    def images
      good.images
    end

    def price
      balances.first.price
    end

    private

    def to_currency(value)
      number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
    end
  end
end
