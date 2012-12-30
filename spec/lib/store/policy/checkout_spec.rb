require "unit_spec_helper"
require "store/policy/checkout"

describe Store::Policy::Checkout do
  let(:payment_gateway) { double(active?: true) }
  let(:store)           { double(payment_gateway: payment_gateway) }
  let(:controller)      { double(current_store: store) }

  it_should_behave_like "loading store contract"

  subject { described_class.new(controller) }

  describe "#enabled?" do
    it "returns false if company has no payment gateway configured" do
      store.stub(:payment_gateway) { nil }
      expect(subject).to_not be_enabled
    end

    it "returns false if payment gateway configuration is incomplete" do
      payment_gateway.stub(:active?) { false }
      expect(subject).to_not be_enabled
    end

    it "returns true if company has payment gateway configured" do
      expect(subject).to be_enabled
    end
  end
end
