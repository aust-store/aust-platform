require "spec_helper"

describe CompanySetting do
  before do
      @settings = FactoryGirl.create(:company_setting)
    end

  describe "hstore methods" do
    specify "zipcode" do
      @settings.zipcode.should == "96360000"

      @settings.zipcode         = "1234567"
      @settings.zipcode.should == "1234567"
    end
  end

  describe "valid_zipcode?" do
    specify "returns true if there's a valid zipcode" do
      @settings.valid_zipcode?.should == true
    end

    specify "adds an error message if there's not a valid zipcode" do
      @settings.errors.size.should == 0

      @settings.zipcode = "1237"
      @settings.valid_zipcode?

      @settings.errors.size.should_not == 0

      puts "============="
      puts @settings.errors.messages[:zipcode]
      puts "============="
    end
  end
end