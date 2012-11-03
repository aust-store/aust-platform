module Admin
  class GoodDecorator < ApplicationDecorator
    decorates :good

    include ::ActionView::Helpers::NumberHelper
    include ::ActionView::Helpers::OutputSafetyHelper

    def description
      raw good.description.gsub("\n", "<br />")
    end

    def has_image?
      good.images.present?
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
      to_currency good.price
    end

    private

    def to_currency(value)
      number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
    end
  end
end
