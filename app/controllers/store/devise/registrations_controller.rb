class Store::Devise::RegistrationsController < Devise::RegistrationsController
  layout "store"

  def new
    resource = build_resource
    address = resource.addresses.build
    respond_with resource
  end

  def create
    build_resource

    resource.store_id = current_store.id
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
end
