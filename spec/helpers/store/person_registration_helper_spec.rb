require "spec_helper"

describe Store::PersonRegistrationHelper do
  describe ".load_person_email" do
    it "returns the person email if one was provided via params" do
      helper.stub(:params) { {email: "email@" } }
      expect(helper.load_person_email).to eq({value: "email@"})
    end

    it "returns an empty hash if no email was provided via params" do
      helper.stub(:params) { {} }
      expect(helper.load_person_email).to eq({})
    end
  end
end
