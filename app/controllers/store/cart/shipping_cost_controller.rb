class Store::Cart::ShippingCostController < Store::ApplicationController
  skip_before_filter :load_taxonomies

  def create
    result = Store::Shipping::CartCalculation.create(self, :br, params)
    if false # result.success?
      render json: {
        zipcode: {
          zipcode: params[:zipcode],
          cost:    Store::Money.new(result.total).to_currency,
          days:    result.days.to_s
        }
      }
    else
      render status: 422, json: { errors: [result.error_message] }
    end
  end

  def cart_items_dimensions
    shipping_boxes = []
    cart.all_items.each do |e|
      e.quantity.to_i.times do |t|
        shipping_boxes << e.inventory_item.shipping_box
      end
    end
    shipping_boxes
  end
end
