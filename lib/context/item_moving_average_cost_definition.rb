module Context
  class ItemMovingAverageCostDefinition
    def initialize(new_entry)
      @new_entry = new_entry
    end

    def define
      # 1. takes all item entries
      entries = item_entries << new_entry

      # 2. calculates moving average cost
      entries.extend(AverageCostCalculator)
      new_cost = entries.calculate_cost

      # 3. saves the new cost into the item
      item = new_entry.inventory_item
      item.extend(AverageCostUpdater)
      item.update_cost(new_cost)
    end

    private

    attr_accessor :new_entry

    def item_entries
      new_entry.inventory_item.entries.where("quantity > 0").to_a
    end

    module AverageCostCalculator
      def calculate_cost
        total_cost > 0 ? total_cost / total_quantity : BigDecimal("0.0")
      end

      private

      def total_quantity
        self.reduce(BigDecimal("0.0")) { |sum, e| sum + BigDecimal(e.quantity) }
      end

      def total_cost
        self.reduce(BigDecimal("0.0")) { |sum, e| sum + e.quantity * e.cost_per_unit }
      end
    end

    module AverageCostUpdater
      def update_cost(cost)
        update_attributes(moving_average_cost: cost)
      end
    end
  end
end
