class Admin::ReportsController < Admin::ApplicationController
  def index

  end

  def sales
    statistics = Store::Statistics::OnlineSales.new(current_company)
    @today            = Money.new(statistics.today, currency)
    @this_month       = Money.new(statistics.this_month, currency)
    @last_thirty_days = Money.new(statistics.last_thirty_days, currency)
  end

  def inventory
    @report = Store::Reports::Inventory.new(current_company).summary
  end
end
