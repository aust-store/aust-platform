module ControllersExtensions
  module CartInstantiation
    def cart
      @cart_object ||= Store::Cart.new(self)
      session[:cart_id] = @cart_object.id
      @cart_object
    end

    def reset_cart
      session[:cart_id] = nil
    end
  end
end
