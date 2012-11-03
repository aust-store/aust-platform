module Store
  class ItemPrice
    def initialize(item)
      @item = item
    end

    def price
      entry_for_sale.price if entry_for_sale
    end

    def entry_for_sale
      @entry_for_sale ||= @item.entry_for_sale
    end
  end
end
