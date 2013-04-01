class Store::CheckoutBaseController < Store::ApplicationController
  before_filter :act_as_target_after_sign_up
  before_filter :authenticate_user!

  def act_as_target_after_sign_up
    session[:redirect_after_sign_in_or_up] = request.env["PATH_INFO"]
  end
end