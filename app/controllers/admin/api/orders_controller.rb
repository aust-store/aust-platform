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
    # Rails demands embedded keys to have _attributes suffix. This class does
    # that for requests coming from other frameworks, e.g. Ember.js
    params[:order] = JsonRequestParser.new(params).add_attributes_suffix["order"]

    cart_id = current_company.carts.find(params[:order][:cart_attributes][:id])
    cart = current_company.carts.find(cart_id)

    sale = Store::Sale.new(cart)
    sale.close

    render json: sale.order
  end
end
