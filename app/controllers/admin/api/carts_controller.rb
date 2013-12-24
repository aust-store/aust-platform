# encoding: utf-8
class Admin::Api::CartsController < Admin::ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    cart = current_company.carts.create_offline(cart_params)
    render json: cart
  end

  private

  def cart_params
    params
      .require(:cart)
      .permit(:id)
  end
end
