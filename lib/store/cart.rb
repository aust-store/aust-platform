module Store
  class Cart
    attr_reader :items

    def initialize
      @items = []
    end

    def add_item(item, quantity = 1)
      quantity.times do
        @items << item
      end
    end

    def remove_item(item)
      @items.delete_if { |i| i.id == item.id }
    end

    def item_quantity(item)
      @items.count { |i| i.id == item.id }
    end

    def total_price
      Store::Cart::PriceCalculation.calculate(@items)
    end

    def total_price_by_item(item)
      items = @items.each_with_object([]) { |i, a| a << i if i.id == item.id }
      Store::Cart::PriceCalculation.calculate(items)
    end
  end
end
