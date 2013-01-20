module Store
  class CartDecorator < ApplicationDecorator
    decorates :cart
    decorates_association :shipping, with: OrderShippingDecorator

    include ::ActionView::Helpers::NumberHelper

    def shipping_price
      shipping.price if cart.shipping
    end

    def shipping_days
      shipping.delivery_days if cart.shipping
    end

    def shipping_type
      shipping.service_type if cart.shipping
    end

    def shipping_zipcode
      shipping.zipcode if cart.shipping
    end

    def total
      to_currency cart.total
    end

    private

    def to_currency(value)
      number_to_currency(value, :unit => "R$ ", :separator => ",", :delimiter => ".")
    end
  end
end
