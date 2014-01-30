# encoding: utf-8
class Admin::Api::StatusController < Admin::Api::ApplicationController
  skip_before_filter :verify_authenticity_token

  def show
    render text: "1"
  end
end
