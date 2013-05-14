class Admin::StatisticsController < Admin::ApplicationController
  def show
    statistics = Store::Statistics::OnlineSales.new(current_company)
    @today            = Money.new(statistics.today, currency)
    @this_month       = Money.new(statistics.this_month, currency)
    @last_thirty_days = Money.new(statistics.last_thirty_days, currency)
  end
end
