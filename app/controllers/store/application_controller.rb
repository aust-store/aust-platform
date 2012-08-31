class Store::ApplicationController < ActionController::Base
  protect_from_forgery
  layout "store"
  before_filter :load_store_information

  def current_store
    @company ||= load_store_information
  end

  def cart
    @cart ||= Store::Cart.new(@company, session[:cart_id])
    session[:cart_id] = @cart.id
    @cart
  end

private

  def load_store_information
    @company = Company.find_by_handle(params[:store_id])
  end
end
