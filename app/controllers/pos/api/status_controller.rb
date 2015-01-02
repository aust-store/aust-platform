# encoding: utf-8
class Pos::Api::StatusController < Pos::Api::ApplicationController
  skip_before_filter :doorkeeper_authorize!

  def show
    render text: "ok"
  end
end
