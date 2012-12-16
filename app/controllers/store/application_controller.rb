class Store::ApplicationController < ApplicationController
  layout "store"

  def current_store
    @company ||= load_store_information
  end

  def cart
    @cart ||= Store::Cart.new(current_store, session[:cart_id])
    session[:cart_id] = @cart.id
    @cart
  end
end
