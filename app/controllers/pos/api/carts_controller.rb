# encoding: utf-8
class Pos::Api::CartsController < Pos::Api::ApplicationController
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
      .require(:carts)
      .permit(:id)

    links = params[:carts][:links]
    if links && links[:customer]
      resource_params.merge!(customer_id: links[:customer])
    end

    resource_params = replace_uuid_with_id(resource_params, current_company.customers, :customer_id)
    replace_id_with_uuid(resource_params)
  end
end
