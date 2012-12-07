class Store::Cart::ShippingCostController < Store::ApplicationController
  def create
    result = Store::Shipping::CartCalculation.create(self, :br, params)
    if result.success?
      render json: {
        zipcode: {
          zipcode: params[:zipcode],
          cost:    Store::Money.new(result.total).to_s,
          days:    result.days.to_s
        }
      }
    else
      render status: 422, json: { error: result.error_message }
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
