class MobileAdmin::ApplicationController < ApplicationController
  layout :define_layout
  before_filter :authenticate_admin_user!

  def current_user
    current_admin_user
  end

  def current_company
    current_user.company
  end

  private

  def define_layout
    request.xhr? ? false : "mobile_admin"
  end
end
