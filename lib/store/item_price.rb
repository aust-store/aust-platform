module Store
  class ItemPrice
    def initialize(item)
      @item = item
    end

    def price
      @item.prices.last.value
    end
  end
end
