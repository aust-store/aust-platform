# encoding: utf-8
class Pos::Api::ApplicationController < ApplicationController
  include ControllersExtensions::ApiFeatures

  skip_before_filter :verify_authenticity_token

  before_action :manual_exit
  before_action :doorkeeper_authorize!
  before_action :set_headers

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

  def current_user
    @current_user ||= if doorkeeper_token && doorkeeper_token.resource_owner_id
                        AdminUser.find(doorkeeper_token.resource_owner_id)
                      end
  end

  def current_company
    current_user.company
  end
end
