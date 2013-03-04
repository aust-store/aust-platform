module Store
  class ItemPrice
    def initialize(item)
      @item = item
    end

    def price
      price = @item.prices.last
      price.present? ? price.value : 0
    end
  end
end
