# encoding: utf-8
class Admin::Api::ApplicationController < Admin::ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :admin_dashboard_redirections

  before_filter :set_headers

  private

  def set_headers
    headers["Endpoint-Purpose"] = "admin"
  end
end
