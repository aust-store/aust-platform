class Store::Cart::ShippingCostController < Store::ApplicationController
  skip_before_filter :load_taxonomies

  def create
    result = ::Store::Cart::ShippingCalculation.create(self)
    if result.success?
      render json: {
        zipcode: {
          zipcode: params[:zipcode],
          cost:    Money.new(result.total).humanize,
          days:    result.days.to_s
        }
      }
    else
      render status: 422, json: { errors: [result.error_message] }
    end
  end

  def cart_items_dimensions
    shipping_boxes = []
    cart.persistence.items.each do |e|
      e.quantity.to_i.times do |t|
        shipping_boxes << e.inventory_item.shipping_box
      end
    end
    shipping_boxes
  end
end
