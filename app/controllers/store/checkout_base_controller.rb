class Store::CheckoutBaseController < Store::ApplicationController
  before_filter :act_as_target_after_sign_up
  before_filter :authenticate_customer!
  before_filter :redirect_on_empty_cart

  def act_as_target_after_sign_up
    session[:redirect_after_sign_in_or_up] = request.env["PATH_INFO"]
  end

  def redirect_on_empty_cart
    if cart.total_unique_items == 0
      redirect_to cart_url, alert: "Carrinho está vazio."
    end
  end
end
