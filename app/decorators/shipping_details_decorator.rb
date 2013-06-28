# encoding: utf-8
class ShippingDetailsDecorator < ApplicationDecorator
  decorates :order_shipping

  include ::ActionView::Helpers::NumberHelper

  def complete_details
    complete = []
    complete << "Custo calculado de #{to_currency(model.price)}"
    complete << "entrega prometida em #{model.delivery_days} dias úteis"
    complete << delivery_by.capitalize if delivery_by.present?
    complete << "serviço #{model.service_type.upcase}"
    complete.join(", ")
  end

  def delivery_by
    model.delivery_type
  end

  private

  def to_currency(value)
    number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end
end
