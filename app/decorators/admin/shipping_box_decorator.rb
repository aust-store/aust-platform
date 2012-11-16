module Admin
  class ShippingBoxDecorator < ApplicationDecorator
    decorates :shipping_box

    def length
      ::Store::Number.new(shipping_box.length).remove_zeros + "cm"
    end

    def width
      ::Store::Number.new(shipping_box.width).remove_zeros + "cm"
    end

    def height
      ::Store::Number.new(shipping_box.height).remove_zeros + "cm"
    end

    def weight
      ::Store::Number.new(shipping_box.weight).remove_zeros + "kg"
    end
  end
end
