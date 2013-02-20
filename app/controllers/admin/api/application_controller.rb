# encoding: utf-8
class Admin::Api::ApplicationController < Admin::ApplicationController
  skip_before_filter :verify_authenticity_token
end
