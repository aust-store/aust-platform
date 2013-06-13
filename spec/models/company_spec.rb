require "spec_helper"

describe Company do
  describe "callbacks" do
    describe "sanitize_domain" do
      it "converts www.domain.com to domain.com" do
        company = FactoryGirl.build(:company, domain: "www.domain.com")
        company.valid?
        expect(company.domain).to eq "domain.com"
      end
    end
  end

  describe "#zipcode" do
    it "returns the company zipcode" do
      company = Company.new
      company.stub(:settings) { double(zipcode: "123") }
      company.zipcode.should == "123"
    end
  end

  describe "#store_theme" do
    it "returns the company store theme" do
      company = Company.new
      company.stub(:settings) { double(store_theme: "overblue") }
      company.store_theme.should == "overblue"
    end
  end

  describe "#has_zipcode?" do
    it "returns true when a zipcode is present" do
      company = Company.new
      company.stub(:zipcode) { "123" }
      company.has_zipcode?.should == true
    end

    it "returns false when zipcode is empty" do
      company = Company.new
      company.stub(:zipcode) { "" }
      company.has_zipcode?.should == false
    end
  end
end
