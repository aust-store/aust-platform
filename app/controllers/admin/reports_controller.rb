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
    @total_items = current_company.items.count
    @total_entries_on_sale = entries_on_sale_on_website.sum(:quantity)

    @stock_value = stock_value
    @stock_estimated_revenue = stock_estimated_revenue
  end

  private

  def entries_on_sale_on_website
    current_company.inventory_entries.on_sale.for_website
  end

  def stock_value
    value = entries_on_sale_on_website
      .joins(:inventory_item)
      .select("SUM(inventory_items.moving_average_cost * inventory_entries.quantity) AS stock_value")
      .group("inventory_items.id")
      .order(false)
      .first
      .attributes["stock_value"].to_f
    Money.new(value, currency)
  end

  def stock_estimated_revenue
    value = current_company
      .items
      .joins(:entries)
      .joins(:prices)
      .select("SUM(inventory_entries.quantity * (SELECT value FROM inventory_item_prices iip ORDER BY iip.id DESC LIMIT 1)) AS estimated_revenue")
      .where("inventory_entries.website_sale='t'")
      .order(false)
      .first
      .attributes["estimated_revenue"].to_f
    Money.new(value, currency)
  end
end
