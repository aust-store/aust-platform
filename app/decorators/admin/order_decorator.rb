module Admin
  class OrderDecorator < ApplicationDecorator
    decorates :order
    decorates_association :items, with: Admin::OrderItemDecorator
    decorates_association :shipping_details, with: ShippingDetailsDecorator
    decorates_association :shipping_address, with: AddressDecorator

    include ::ActionView::Helpers::NumberHelper

    def total
      to_currency(order.total)
    end

    def payment_status
      I18n.t("activerecord.values.payment_status.#{order.current_payment_status}")
    end

    def summary_long_text
      I18n.t("activerecord.values.order.summary.#{order.summary}")
    end

    def purchase_date
      order.created_at.strftime("%d/%m/%Y %H:%M")
    end

    private

    def to_currency(value)
      number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
    end
  end
end
