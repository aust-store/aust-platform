module Store
  class Cart
    attr_reader :items, :persistence

    def initialize(company, cart_id)
      @company = company
      @cart_id = cart_id
      persist_cart
    end

    def id
      persistence.id
    end

    def add_item(inventory_entry_id, quantity = 1)
      persistence.add_item(inventory_entry_id, quantity)
    end

    def items
      Store::Cart::ItemsDisplay.new(self).list
    end

    def all_items
      persistence.items.all
    end

    def total_price
      Store::Cart::PriceCalculation.calculate(@items)
    end

    def total_price_by_item(item)
      items = @items.each_with_object([]) { |i, a| a << i if i.id == item.id }
      Store::Cart::PriceCalculation.calculate(items)
    end

  private

    def persist_cart
      @persistence = ::Cart.find(@cart_id)
    rescue ActiveRecord::RecordNotFound
      @persistence = ::Cart.create(company: @company)
    end
  end
end
