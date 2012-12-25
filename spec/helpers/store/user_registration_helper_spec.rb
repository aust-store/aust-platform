require "spec_helper"

describe Store::UserRegistrationHelper do
  describe ".load_user_email" do
    it "returns the user email if one was provided via params" do
      helper.stub(:params) { {email: "email@" } }
      expect(helper.load_user_email).to eq({value: "email@"})
    end

    it "returns an empty hash if no email was provided via params" do
      helper.stub(:params) { {} }
      expect(helper.load_user_email).to eq({})
    end
  end
end
