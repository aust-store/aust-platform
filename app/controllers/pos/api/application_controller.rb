# encoding: utf-8
class Pos::Api::ApplicationController < ApplicationController
  include ControllersExtensions::ApiFeatures

  skip_before_filter :verify_authenticity_token

  before_filter :set_headers
  before_filter :manual_exit
  before_filter :authenticate_api_token

  private

  def manual_exit
    #exit
  end

  def set_headers
    headers["Endpoint-Purpose"] = "point_of_sale"
    if Rails.env.test? || Rails.env.development?
      headers["Access-Control-Allow-Origin"] = "http://localhost:4200"
    end
  end

  def authenticate_api_token
    authenticate_or_request_with_http_token do |token, options|
      @current_user = AdminUser.find_by_api_token(token)
    end
  end

  def current_user
    @current_user
  end

  def current_company
    current_user.company
  end
end
