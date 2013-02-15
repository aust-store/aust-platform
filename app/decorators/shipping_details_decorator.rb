# encoding: utf-8
class ShippingDetailsDecorator < ApplicationDecorator
  decorates :order_shipping

  include ::ActionView::Helpers::NumberHelper

  def complete_details
    complete = []
    complete << "Custo #{to_currency(order_shipping.price)}"
    complete << "entrega prometida em #{order_shipping.delivery_days} dias úteis"
    complete << delivery_by.capitalize if delivery_by.present?
    complete << "serviço #{order_shipping.service_type.upcase}"
    complete.join(", ")
  end

  def delivery_by
    order_shipping.delivery_type
  end

  private

  def to_currency(value)
    number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end
end
