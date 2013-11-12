module Store
  class Cart
    attr_reader :items, :persistence, :user

    def initialize(controller)
      @company = controller.current_store
      @user    = controller.current_customer
      @cart_id = controller.session[:cart_id]
      persisted_cart
    end

    def id
      (persistence and persistence.id) || @cart_id
    end

    def current_company
      @company
    end

    def add_item(inventory_entry, quantity = 1)
      persistence.reset_shipping
      persistence.add_item(inventory_entry, quantity)
    end

    def remove_item(id)
      persistence.items.destroy(id)
    end

    def current_items
      Store::Cart::ItemsList.new(self).list
    end

    def parent_items
      persistence.items.parent_items
    end

    def total_unique_items
      persistence.items.count
    end

    def total_price
      Store::Order::PriceCalculation.calculate(parent_items)
    end

    def total_price_by_item(item)
      items = @items.each_with_object([]) { |i, a| a << i if i.id == item.id }
      Store::Order::PriceCalculation.calculate(items)
    end

    def persisted_cart
      @persistence = ::Cart.find_or_create_cart(self)
    end

    def update(params)
      Store::Cart::Update.new(self).update(params)
    end

    def shipping_address
      persistence.shipping_address
    end

    def shipping_options
      persistence.shipping
    end

    def convert_into_order
      persistence.convert_into_order
    end
  end
end
