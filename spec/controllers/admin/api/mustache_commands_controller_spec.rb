require 'spec_helper'

describe Admin::Api::MustacheCommandsController do
  login_admin

  describe "GET index" do
    it "returns all files" do
      get :index
      json = ActiveSupport::JSON.decode(response.body)

      json["mustache_commands"].should =~ ThemeDocumentation.new.to_json
    end
  end
end
