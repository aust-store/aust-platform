# encoding: utf-8
class Pos::Api::StatusController < Pos::Api::ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_api_token

  def show
    render text: "ok"
  end
end
