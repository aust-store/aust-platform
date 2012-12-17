class ApplicationController < ActionController::Base
  protect_from_forgery

  include ControllersExtensions::LoadingCompanyAccordingToDomain

  def current_store
    @company ||= load_store_information
  end
end
