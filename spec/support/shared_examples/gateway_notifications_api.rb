shared_examples "gateway notifications api" do
  describe "Gateway Notifications class" do
    specify "#order_id raises by default" do
      expect do
        subject.order_id
      end.to_not raise_error Store::GatewayNotifications::UndefinedInterface
    end

    specify "#unique_id_within_gateway raises by default" do
      expect do
        subject.unique_id_within_gateway
      end.to_not raise_error Store::GatewayNotifications::UndefinedInterface
    end

    specify "#status raises by default" do
      expect do
        subject.status
      end.to_not raise_error Store::GatewayNotifications::UndefinedInterface
    end
  end
end
