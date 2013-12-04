require "spec_helper"

describe View::GoogleAnalytics do
  it_should_behave_like "a rails request"

  let(:company_settings) { build(:company_setting) }
  let(:company) { build(:company, settings: company_settings) }

  let(:controller) { double(request: :request) }

  subject { described_class.new(company, controller) }

  describe "#enabled?" do
    it "returns true if GA is enabled" do
      subject.should be_enabled
    end

    it "returns false if GA is inactive" do
      company_settings.google_analytics_id = nil
      subject.should_not be_enabled
    end
  end

  describe "#tracking_id" do
    it "returns the configured id" do
      subject.tracking_id.should == "UA-2345678-1"
    end
  end

  describe "#domain" do
    context "domain is www.petshop.com" do
      before do
        company.domain = "www.petshop.com"
      end

      it "returns the configured id" do
        subject.domain.should == "www.petshop.com"
      end
    end

    context "domain is petshop.com.br" do
      before do
        company.domain = "petshop.com.br"
      end

      it "returns the configured id" do
        subject.domain.should == "petshop.com.br"
      end
    end

    context "domain is petshop.com" do
      before do
        company.domain = "petshop.com"
      end

      it "returns the configured id" do
        subject.domain.should == "petshop.com"
      end
    end

    context "company doesn't have a domain" do
      let(:rails_request) { double(current_domain: "petshop.com") }

      before do
        company.domain = ""
        ::RailsRequest.stub(:new) { rails_request }
      end

      it "returns the configured id" do
        subject.domain.should == "petshop.com"
      end
    end
  end
end
