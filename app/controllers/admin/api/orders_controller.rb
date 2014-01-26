# encoding: utf-8
class Admin::Api::OrdersController < Admin::Api::ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @resources = current_company.orders.includes(:payment_statuses).order('id desc')

    @resources = @resources.created_offline        if params[:environment] == "offline"
    @resources = @resources.created_on_the_website if params[:environment] == "website"

    paginate_resource
    render json: @resources, meta: meta
  end

  def create
    cart = current_company.carts.find_by_uuid(order_params[:cart_id])

    sale = Store::Sale.new(cart, order_uuid: order_id)
    sale.close

    render json: sale.order, include_items: true
  end

  private

  def order_id
    order_params[:id]
  end

  def order_params
    params
      .require(:order)
      .permit(:id, :cart_id)
  end
end
