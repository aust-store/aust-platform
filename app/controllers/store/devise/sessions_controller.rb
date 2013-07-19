Devise.parent_controller = "Store::ApplicationController"

class Store::Devise::SessionsController < Devise::SessionsController
  before_filter :configure_permitted_parameters

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:email, :password)
    end

    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :name)
    end
  end
end
