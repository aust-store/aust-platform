module Admin
  class ShippingBoxDecorator < ApplicationDecorator
    decorates :shipping_box

    def length
      return if shipping_box.length.blank? || shipping_box.length.zero?
      ::Store::Number.new(shipping_box.length).remove_zeros.to_s + "cm"
    end

    def width
      return if shipping_box.width.blank? || shipping_box.width.zero?
      ::Store::Number.new(shipping_box.width).remove_zeros.to_s + "cm"
    end

    def height
      return if shipping_box.height.blank? || shipping_box.height.zero?
      ::Store::Number.new(shipping_box.height).remove_zeros.to_s + "cm"
    end

    def weight
      return if shipping_box.weight.blank? || shipping_box.weight.zero?
      ::Store::Number.new(shipping_box.weight).remove_zeros.to_s + "kg"
    end
  end
end
