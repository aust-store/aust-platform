# encoding: utf-8
class Admin::Api::CartItemsController < Admin::ApplicationController
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
    cart = current_company.carts.find(cart_id)
    item = cart.items.build(cart_item_params)
    item.save

    render json: item, serializer: CartItemSerializer
  end

  private

  def cart_id
    cart_item_params[:cart_id]
  end

  def cart_item_params
    params
      .require(:cart_item)
      .permit(:price, :inventory_entry_id, :cart_id, :inventory_item_id)
  end
end
