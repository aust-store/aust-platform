require 'spec_helper'

describe Admin::ThemeEditorController do

  describe "GET 'show'" do
    it "returns http success" do
      Theme.stub(:find).with("2")
      get 'show', id: 2
      response.should be_success
    end
  end
end
