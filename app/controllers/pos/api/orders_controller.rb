# encoding: utf-8
class Pos::Api::OrdersController < Pos::Api::ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @resources = current_company.orders.includes(:payment_statuses).order('id desc')
    @resources = @resources.created_offline

    @resources = @resources.where(payment_type: params[:payment_type]) if params[:payment_type]

    only_current_user_resources
    search_by_date
    paginate_resource
    render json: @resources, meta: meta, root: "orders", include: 'customer,cart'
  end

  def create
    cart = current_company.carts.find_by_uuid(order_params[:cart_id])

    sale = Store::Sale.new(cart,
                           uuid: order_uuid,
                           admin_user_id: current_user.id,
                           payment_type: payment_type)
    sale.close

    render json: sale.order, include_items: true
  end

  private

  def order_uuid
    order_params[:uuid]
  end

  def payment_type
    order_params[:payment_type]
  end

  def order_params
    deserializer = ActiveModel::Deserializer.new(params)
    resource_params = deserializer
      .require(:orders)
      .permit(:id, :payment_type, :created_at)
      .associations(:cart, :order_items)

    resource_params = replace_id_with_uuid(resource_params)
  end
end
