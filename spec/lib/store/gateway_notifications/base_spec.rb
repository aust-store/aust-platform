require "store/gateway_notifications/base"
require "unit_spec_helper"

class DummyGatewayNotificationApi < Store::GatewayNotifications::Base; end

describe DummyGatewayNotificationApi do
  it_should_behave_like "gateway notifications api"
end

describe Store::GatewayNotifications::Base do
  subject { Store::GatewayNotifications::Base.new(double) }

  specify "#order_id raises by default" do
    expect do
      subject.order_id
    end.to raise_error Store::GatewayNotifications::UndefinedInterface
  end

  specify "#unique_id_within_gateway raises by default" do
    expect do
      subject.unique_id_within_gateway
    end.to raise_error Store::GatewayNotifications::UndefinedInterface
  end

  specify "#status raises by default" do
    expect do
      subject.status
    end.to raise_error Store::GatewayNotifications::UndefinedInterface
  end
end
