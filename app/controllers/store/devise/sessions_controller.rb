class Store::Devise::SessionsController < Devise::SessionsController
  layout "store"
  before_filter :configure_permitted_parameters

  include ControllersExtensions::CartInstantiation
  include ControllersExtensions::Store::ViewObjects

  # e. g loads taxonomies, cart item quantities
  include ControllersExtensions::Resources

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
