module ControllersExtensions
  module CartInstantiation
    def cart
      @cart ||= Store::Cart.new(self)
      session[:cart_id] = @cart.id
      @cart
    end
  end
end
