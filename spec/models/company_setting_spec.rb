require "spec_helper"

describe CompanySetting do
  describe "hstore methods" do
    before do
      @settings = FactoryGirl.build(:company_setting)
    end

    specify "zipcode" do
      @settings.zipcode.should == "96360000"
      @settings.zipcode = "1234567"
      @settings.zipcode.should == "1234567"
    end
  end
end
