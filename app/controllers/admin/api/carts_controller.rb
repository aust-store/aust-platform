# encoding: utf-8
class Admin::Api::CartsController < Admin::ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    cart = current_company.carts.create_offline(cart_params)
    render json: cart
  end

  def update
    cart = current_company.carts.point_of_sale.find(params[:id])
    cart.update_attributes(cart_params)
    render json: cart
  end

  private

  def cart_params
    params
      .require(:cart)
      .permit(:customer_id)
  end
end
