require "spec_helper"

describe Store::CustomerRegistrationHelper do
  describe ".load_customer_email" do
    it "returns the customer email if one was provided via params" do
      helper.stub(:params) { {email: "email@" } }
      expect(helper.load_customer_email).to eq({value: "email@"})
    end

    it "returns an empty hash if no email was provided via params" do
      helper.stub(:params) { {} }
      expect(helper.load_customer_email).to eq({})
    end
  end
end
