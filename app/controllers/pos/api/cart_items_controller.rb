# encoding: utf-8
class Pos::Api::CartItemsController < Pos::Api::ApplicationController
  before_action :doorkeeper_authorize!

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
    cart = current_company.carts.find_by_uuid(cart_id)
    item = cart.items.build(cart_item_params)
    item.save

    render json: item, serializer: CartItemSerializer, include: 'inventory_item'
  end

  def destroy
    cart_item = ::OrderItem.find_by_uuid(params[:id])
    cart_item.destroy if cart_item && cart_item.cart.company == current_company
  rescue ActiveRecord::StatementInvalid
  ensure
    render json: {}
  end

  private

  def cart_id
    cart_item_params[:cart_id]
  end

  def cart_item_params
    deserializer = ActiveModel::Deserializer.new(params)
    resource_params = deserializer
      .require(:cart_items)
      .permit(:id, :price, :price_for_installments, :inventory_entry_id)
      .associations(:cart, :inventory_item)

    resource_params = replace_uuid_with_id(resource_params,
                                           current_company.items,
                                           :inventory_item_id)
    replace_id_with_uuid(resource_params)
  end
end
