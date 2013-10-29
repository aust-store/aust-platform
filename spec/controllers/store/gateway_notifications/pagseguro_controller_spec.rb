require 'spec_helper'

describe Store::GatewayNotifications::PagseguroController do
  before do
    @store = FactoryGirl.create(:company)
    @store.build_payment_gateway(
      email: "user@example.com",
      name:  "pagseguro",
      token: "1234"
    )
    @store.save
    controller.stub(:current_store) { @store }
  end

  describe "POST create" do
    it "triggers the status change" do
      PagSeguro::Notification
        .stub(:new)
        .with("user@example.com", "1234", "notification_code")
        .and_return(:notification)

      Store::GatewayNotifications::PagseguroWrapper.stub(:new).with(:notification) { :notification_wrapper }
      Store::Order::StatusChange.should_receive(:change).with(:notification_wrapper)

      post :create, notificationCode: "notification_code"
    end
  end
end
