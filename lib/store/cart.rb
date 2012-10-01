module Store
  class Cart
    attr_reader :items, :persistence

    def initialize(company, cart_id)
      @company = company
      @cart_id = cart_id
      persisted_cart
    end

    def id
      @cart_id || (persistence && persistence.id)
    end

    def current_company
      @company
    end

    def add_item(inventory_entry_id, quantity = 1)
      persistence.add_item(inventory_entry_id, quantity)
    end

    def current_items
      Store::Cart::ItemsList.new(self).list
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

    def persisted_cart(cart = ::Cart)
      @persistence = cart.find_or_create_cart(self)
    end
  end
end
