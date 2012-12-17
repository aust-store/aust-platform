module ControllersExtensions
  module StoreApplication
    def cart
      @cart ||= Store::Cart.new(@company, session[:cart_id])
      session[:cart_id] = @cart.id
      @cart
    end
  end
end
