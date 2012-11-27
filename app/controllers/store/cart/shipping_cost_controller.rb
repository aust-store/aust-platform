class Store::Cart::ShippingCostController < Store::ApplicationController
  def create
    calc = Store::Shipping::CartCalculation.new(self, :br)
    result = calc.create(params[:zipcode], params[:type])
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
    cart.all_items.map { |e| e.inventory_item.shipping_box }
  end
end
