# encoding: utf-8
class Admin::Api::CartsController < Admin::ApplicationController
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
    params[:cart] = JsonRequestParser.new(params).add_attributes_suffix["cart"]
    params[:cart][:user_id] = current_user.id
    cart = current_company.carts.create_offline(params[:cart])

    respond_to do |format|
      format.js { render json: cart }
    end
  end

  def update
    params[:cart] = JsonRequestParser.new(params).add_attributes_suffix["cart"]
    cart = current_company.carts.find(params[:id])

    if cart.update_attributes(params[:cart])
      render json: cart
    else
      render json: cart
    end
  end
end
