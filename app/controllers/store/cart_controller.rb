class Store::CartController < Store::ApplicationController
  layout "store"

  def show
    @cart_items = cart.current_items
    render "empty" and return if @cart_items.blank?
  end
end
