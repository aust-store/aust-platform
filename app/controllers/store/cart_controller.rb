class Store::CartController < Store::ApplicationController
  layout "store"

  before_filter :redirect_if_sales_disabled

  def show
    @checkout_enabled = Store::Policy::Checkout.new(self).enabled?
    @cart_items       = cart.current_items
    @cart             = DecorationBuilder.cart(cart.persistence)
    @shipping_calculation_enabled = current_store.has_zipcode?

    render "empty" and return if @cart_items.blank?
  end

  def update
    cart.update(params[:cart])
    ::Store::CartShippingCalculation.create(self, shipping_options)
    redirect_to cart_url
  end

  private

  def shipping_options
    { destination_zipcode: params[:zipcode],
      type:                params[:type] }
  end


  def redirect_if_sales_disabled
    redirect_to root_path unless current_store.sales_enabled?
  end
end
