module Store
  class Sale
    attr_accessor :order

    def initialize(cart)
      @cart = cart
    end

    def close
      new_order_from_cart
      subtract_items_from_stock
    end

    private

    attr_reader :cart

    def new_order_from_cart
      @order ||= Store::Order::CreationFromCart.new(cart).convert_cart_into_order
    end

    def subtract_items_from_stock
      Store::Stock::DecrementAfterOrder.new(@order).subtract
    end
  end
end
