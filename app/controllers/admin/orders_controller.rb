class Admin::OrdersController < Admin::ApplicationController
  def index
    orders = current_company
      .orders
      .includes(:payment_statuses)
      .created_on_the_website
      .order('id desc')
      .last(50)
    @orders = Admin::OrderDecorator.decorate(orders)
  end

  def show
    order = current_company.orders.find(params[:id])
    @order = Admin::OrderDecorator.decorate(order)
  end

  def edit
  end

  def update
    @order = current_company.orders.find(params[:id])

    if @order.update_attributes(params[:order])
      redirect_to admin_order_url(@order)
    else
      @order = Admin::OrderDecorator.decorate(@order)
      render "show"
    end
  end
end
