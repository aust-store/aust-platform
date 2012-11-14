module Admin
  class ShippingBoxDecorator < ApplicationDecorator
    decorates :shipping_box

    def length
      ::Store::Number.new(shipping_box.length).remove_zeros
    end

    def width
      ::Store::Number.new(shipping_box.width).remove_zeros
    end

    def height
      ::Store::Number.new(shipping_box.height).remove_zeros
    end

    def weight
      ::Store::Number.new(shipping_box.weight).remove_zeros
    end
  end
end
