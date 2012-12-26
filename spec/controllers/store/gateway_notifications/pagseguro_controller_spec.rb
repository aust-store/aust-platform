require 'spec_helper'

describe Store::GatewayNotifications::PagseguroController do
  describe "POST create" do
    it "triggers the status change" do

      PagSeguro::Notification.stub(:new).with("email", "token", "1234") { :notification }
      Store::GatewayNotifications::PagseguroWrapper.stub(:new).with(:notification) { :notification_wrapper }

      Store::Order::StatusChange.should_receive(:change).with(:notification_wrapper)

      post :create, notificationCode: "1234"
    end
  end
end
