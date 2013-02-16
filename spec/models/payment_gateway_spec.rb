require 'spec_helper'

describe PaymentGateway do
  describe "callbacks" do
    describe "sanitize_token on validation" do
      it "strip token whitespaces on validation" do
        gateway = PaymentGateway.new(token: " 1234 ")
        expect(gateway.token).to eq " 1234 "
        gateway.valid?
        expect(gateway.token).to eq "1234"
      end

      it "doesn't try stripping token whitespaces if it's nil" do
        gateway = PaymentGateway.new
        expect(gateway.token).to be_nil
        gateway.valid?
        expect(gateway.token).to be_nil
      end
    end
  end
end
