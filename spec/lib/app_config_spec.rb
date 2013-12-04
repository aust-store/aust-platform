require "spec_helper"

describe AppConfig do
  let(:prod_config) { YAML.load_file(Rails.root.join('config/config.yml'))["production"] }

  subject { described_class }

  describe "#method_missing" do
    describe "google_analytics?" do
      it "returns true for production" do
        subject.stub(:config) { prod_config }
        subject.google_analytics?.should === true
      end

      it "returns false by anything" do
        subject.google_analytics?.should === false
      end
    end
  end
end
