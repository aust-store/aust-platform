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
      .where("orders.created_at >= ?", Time.now.beginning_of_day)
      .where("orders.environment = ?", environment)
      .sum("orders.total")
  end

  def total_revenue
    revenue
  end

  def revenue
    @revenue ||= current_company.orders
  end
end
