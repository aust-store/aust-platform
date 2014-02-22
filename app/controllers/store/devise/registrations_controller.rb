class Store::Devise::RegistrationsController < Devise::RegistrationsController
  layout "store"
  before_filter :configure_permitted_parameters

  include ControllersExtensions::CartInstantiation
  include ControllersExtensions::Store::ViewObjects

  # e. g loads taxonomies, cart item quantities
  include ControllersExtensions::Resources

  def new
    resource = build_resource
    resource.addresses.build
    respond_with resource
  end

  def create
    self.resource = build_resource(sign_up_params)

    resource.store_id = current_store.id
    resource.environment = "website"
    resource.roles << Role.customer.first
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  protected

  def after_sign_up_path_for(resource)
    path = session[:redirect_after_sign_in_or_up]
    if path.present?
      session[:redirect_after_sign_in_or_up] = nil
      path
    else
      super(resource)
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name,
               :email,
               :last_name,
               :password,
               :password_confirmation,
               :social_security_number,
               :home_area_number,
               :home_number,
               :mobile_area_number,
               :mobile_number,
               :receive_newsletter,
               addresses_attributes: [
                 :address_1,
                 :address_2,
                 :number,
                 :neighborhood,
                 :zipcode,
                 :city,
                 :state
               ])
    end
  end
end
