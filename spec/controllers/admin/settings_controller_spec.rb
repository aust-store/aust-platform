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
      put :update, company_setting: { "zipcode" => "1234567" }
    end

    context "when update occurs successfully" do
      before do
        @settings.stub(:zipcode) { 96360000 }
        @settings.stub(:update_attributes) { true }
      end

      it "renders the form again with a success message" do
        put :update, company_setting: { zipcode: 1234567 }
        response.should redirect_to admin_settings_url
      end
    end

    context "when update doesn't occur" do
      it "renders the form again" do
        @settings.should_receive(:update_attributes) { false }
        put :update, company_setting: { "zipcode" => "1237" }
        response.should render_template "show"
      end
    end
  end
end
