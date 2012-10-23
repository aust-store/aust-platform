module Store
  class ItemPrice
    def initialize(item)
      @item = item
    end

    def price
      if entry_for_sale
        entry_for_sale.price
      end
    end

    def entry_for_sale
      @entry_for_sale ||= @item.balances.first
    end
  end
end
