class Store::Devise::RegistrationsController < Devise::RegistrationsController
  layout "store"

  def new
    resource = build_resource
    address = resource.addresses.build
    respond_with resource
  end

  private

  def after_sign_up_path_for(resource)
    path = session[:redirect_after_sign_in_or_up]
    if path
      session[:redirect_after_sign_in_or_up] = nil
      path
    else
      super
    end
  end
end
