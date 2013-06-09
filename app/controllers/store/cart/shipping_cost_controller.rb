class Store::Cart::ShippingCostController < Store::ApplicationController
  skip_before_filter :load_taxonomies

  def create
    result = ::Store::CartShippingCalculation.create(self, shipping_options)
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

  private

  def shipping_options
    { destination_zipcode: params[:zipcode],
      type:                params[:type] }
  end
end
