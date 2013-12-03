# encoding: utf-8
class Admin::Api::MustacheCommandsController < Admin::ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    mustache_commands = ThemeDocumentation.new
    json = mustache_commands.to_json.sort_by { |s| s["group"] }

    render json: { mustache_commands: json }
  end
end
