# encoding: utf-8
class Admin::Api::OrdersController < Admin::ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    orders = current_company
      .orders
      .includes(:payment_statuses)
      .order('id desc')
      .last(50)

    render json: orders
  end

  def create
    params[:order] = JsonRequestParser.new(params).add_attributes_suffix["order"]

    cart_id = current_company.carts.find(params[:order][:cart_attributes][:id])
    cart = current_company.carts.find(cart_id)
    order = cart.convert_into_order

    respond_to do |format|
      format.js { render json: order }
    end
  end
end
