require 'spec_helper'

describe Admin::ThemeEditorController do
  login_admin

  describe "GET 'show'" do
    it "returns http success" do
      theme = double
      controller.stub(:current_company) { :company }
      Theme.stub(:accessible_for_company).with(:company) { theme }
      theme.stub(:find).with("2")
      get 'show', id: 2
      response.should be_success
    end
  end
end
