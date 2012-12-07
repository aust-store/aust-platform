class Store::CartController < Store::ApplicationController
  layout "store"

  def show
    @cart_items = cart.current_items
    @cart = DecorationBuilder.cart(cart.persistence)
    render "empty" and return if @cart_items.blank?
  end

  def update
    cart.update(params[:cart])
    redirect_to store_cart_url
  end
end
