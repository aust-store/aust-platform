require "spec_helper"

describe Admin::StoreThemesController do
  login_admin

  describe "POST create" do
    it "creates a new theme" do
      Theme.should_receive(:create_for_company).with(controller.current_company)
      post :create
    end
  end
end
