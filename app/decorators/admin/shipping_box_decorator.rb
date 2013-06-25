module Admin
  class ShippingBoxDecorator < ApplicationDecorator
    decorates :shipping_box

    def length
      return if model.length.blank? || model.length.zero?
      ::Store::Number.new(model.length).remove_zeros.to_s + "cm"
    end

    def width
      return if model.width.blank? || model.width.zero?
      ::Store::Number.new(model.width).remove_zeros.to_s + "cm"
    end

    def height
      return if model.height.blank? || model.height.zero?
      ::Store::Number.new(model.height).remove_zeros.to_s + "cm"
    end

    def weight
      return if model.weight.blank? || model.weight.zero?
      ::Store::Number.new(model.weight).remove_zeros.to_s + "kg"
    end
  end
end
