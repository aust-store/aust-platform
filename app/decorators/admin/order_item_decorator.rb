module Admin
  class OrderItemDecorator < ApplicationDecorator
    decorates :order_item

    include ::ActionView::Helpers::NumberHelper

    def price
      to_currency(order_item.price)
    end

    def status
      I18n.t("activerecord.values.order_item.status.#{order_item.status}")
    end

    private

    def to_currency(value)
      number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
    end
  end
end
