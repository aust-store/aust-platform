class Admin::Api::Reports::OrdersStatisticsController < Admin::Api::ApplicationController
  def show
    revenue = current_company.orders.joins(:items)

    if params[:period].present?
      revenue = define_period(revenue)
    end

    revenue = revenue.sum("order_items.price")

    render json: {
      orders_statistics: [{
        revenue: revenue
      }]
    }
  end

  private

  def define_period(revenue)
    case params[:period]
    when "today" then
      revenue.where("order_items.created_at >= ?", Time.zone.now.beginning_of_day)
    else
      revenue
    end
  end
end
