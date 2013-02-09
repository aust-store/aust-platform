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
    params[:order][:user_id] = current_user.id
    order = current_company.orders.create_offline(params[:order])

    respond_to do |format|
      format.js { render json: order }
    end
  end

  def update
    params[:order] = JsonRequestParser.new(params).add_attributes_suffix["order"]
    order = current_company.orders.find(params[:id])

    if order.update_attributes(params[:order])
      render json: order
    else
      render json: order
    end
  end
end
