require 'spec_helper'

describe Admin::SettingsController do
  login_admin

  describe "PUT update" do
    before do
      @settings = FactoryGirl.build(:company_setting)
      @settings.stub(:update_attributes)
      controller.current_company.stub(:settings) { @settings }
    end

    it "updates the company settings" do
      @settings.should_receive(:update_attributes).with({"zipcode" => "1234567"})
      xhr :put, :update, company_setting: { "zipcode" => "1234567" }
    end

    context "when update occurs successfully" do
      before do
        @settings.stub(:zipcode) { "96360000" }
        @settings.stub(:update_attributes) { true }
        xhr :put, :update, company_setting: { zipcode: "1234567" }
      end

      it "returns 200" do
        response.status.should == 200
      end

      it "returns the settings" do
        json = { "company_setting" => {
          "id" => nil, "zipcode" => "96360000", "updated_at" => nil }
        }
        response.body.should == ActiveSupport::JSON.encode(json)
      end
    end

    context "when update doesn't occur" do
      before do
        @settings.stub(:update_attributes) { false }
        xhr :put, :update, company_setting: { zipcode: "1234567" }
      end

      it "returns 422" do
        response.status.should == 422
      end

      it "returns the error messages" do
        response.body.should == ActiveSupport::JSON.encode({errors: []})
      end
    end
  end
end
