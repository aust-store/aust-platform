# encoding: utf-8
class Admin::Api::OrdersController < Admin::ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    orders = current_company
      .orders
      .includes(:payment_statuses)
      .order('id desc')
      .limit(50)

    orders = orders.created_offline        if params[:environment] == "offline"
    orders = orders.created_on_the_website if params[:environment] == "website"
    orders = orders.to_a

    render json: orders
  end

  def create
    cart = current_company.carts.find_by_uuid(order_params[:cart_id])

    sale = Store::Sale.new(cart)
    sale.close

    render json: sale.order, include_items: true
  end

  private

  def order_params
    params
      .require(:order)
      .permit(:cart_id)
  end
end
