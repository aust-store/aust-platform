class OrderShippingDecorator < ApplicationDecorator
  decorates :order_shipping

  include ::ActionView::Helpers::NumberHelper

  def price
    to_currency model.price
  end

  private

  def to_currency(value)
    number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
  end
end
