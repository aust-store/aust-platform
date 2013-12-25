class Admin::Api::StoreReportsController < Admin::Api::ApplicationController
  def show
    render json:{
      store_reports: [{
        id: "today_offline",
        period: "today",
        environment: "offline",
        revenue: today_revenue(:offline)
      }]
    }, serializer: false
  end

  private

  def period
    params[:period] || "today"
  end

  def today_revenue(environment = :website)
    revenue
      .where("order_items.created_at >= ?", Time.zone.now.beginning_of_day)
      .where("orders.environment = ?", environment)
      .sum("order_items.price")
  end

  def total_revenue
    revenue
  end

  def revenue
    @revenue ||= current_company.orders.joins(:items)
  end
end
