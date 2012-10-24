module Store
  class InventoryItemDecorator < ApplicationDecorator
    decorates :good

    include ::ActionView::Helpers::NumberHelper

    def price
      to_currency balances.first.price
    end

    private

    def to_currency(value)
      number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
    end
  end
end
