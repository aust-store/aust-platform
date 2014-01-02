# encoding: utf-8
class Admin::Api::CartsController < Admin::Api::ApplicationController
  def create
    cart = current_company.carts.create_offline(cart_params)
    render json: cart
  end

  def update
    cart = current_company.carts.point_of_sale.find_by_uuid(params[:id])
    cart.update_attributes(cart_params)
    render json: cart
  end

  private

  def cart_params
    resource_params = params
      .require(:cart)
      .permit(:id, :customer_id)

    resource_params = replace_uuid_with_id(resource_params, current_company.customers, :customer_id)
    replace_id_with_uuid(resource_params)
  end
end
