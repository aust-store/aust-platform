module Store
  class ItemPrice
    def initialize(item)
      @item = item
    end

    def price
      price_record.present? ? price_record.value : 0
    end

    def price_for_installments
      price_record.present? ? price_record.for_installments : 0
    end

    private

    def price_record
      @item.prices.last
    end
  end
end
