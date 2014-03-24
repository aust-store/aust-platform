module Store
  module Reports
    class Inventory
      def initialize(company)
        @company = company
      end

      def summary
        {
          total_inventory_items: total_inventory_items,
          total_entries: total_entries,
          total_entries_on_sale_at_website: total_entries_on_sale_at_website,
          total_entries_on_sale_at_pos: total_entries_on_sale_at_pos,
          stock_value: stock_value,
          stock_estimated_revenue: stock_estimated_revenue
        }
      end

      private

      attr_reader :company

      def total_inventory_items
        company.items.count
      end

      def total_entries
        company.inventory_entries.sum(:quantity).to_i
      end

      def entries_on_sale
        company.inventory_entries.on_sale
      end

      def total_entries_on_sale_at_website
        company.inventory_entries.on_sale.for_website.sum(:quantity).to_i
      end

      def total_entries_on_sale_at_pos
        company.inventory_entries.on_sale.for_point_of_sale.sum(:quantity).to_i
      end

      def stock_estimated_revenue
        value = company
          .items
          .joins(:entries)
          .select("SUM(inventory_entries.quantity * (SELECT value FROM inventory_item_prices iip2 WHERE iip2.inventory_item_id=inventory_items.id ORDER BY iip2.id DESC LIMIT 1)) AS estimated_revenue")
          .order(false)
          .first
          .attributes["estimated_revenue"].to_f
        Money.new(value, company.currency)
      end

      def stock_value
        value = company
          .items
          .joins(:entries)
          .select("SUM(inventory_items.moving_average_cost * inventory_entries.quantity) AS stock_value")
          .order(false)
          .first
          .attributes["stock_value"].to_f
        Money.new(value, company.currency)
      end
    end
  end
end
