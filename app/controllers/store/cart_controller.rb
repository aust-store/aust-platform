class Store::CartController < Store::ApplicationController
  layout "store"

  def show
    @cart_items = cart.items
    render "empty" and return if @cart_items.blank?
  end
end
