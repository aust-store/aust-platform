module ControllersExtensions
  module CartInstantiation
    def cart
      @cart ||= Store::Cart.new(self)
      session[:cart_id] = @cart.id
      @cart
    end

    def reset_cart
      session[:cart_id] = nil
    end
  end
end
