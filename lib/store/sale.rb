module Store
  class Sale
    attr_accessor :order

    #
    # options could be the predefined UUID of the order
    def initialize(cart, options = {})
      @cart = cart
      @options = options
    end

    def close
      new_order_from_cart
      subtract_items_from_stock
    end

    private

    attr_reader :cart, :options

    def new_order_from_cart
      @order ||= Store::Order::CreationFromCart.new(cart, options).convert_cart_into_order
    end

    def subtract_items_from_stock
      Store::Stock::DecrementAfterOrder.new(@order).subtract
    end
  end
end
