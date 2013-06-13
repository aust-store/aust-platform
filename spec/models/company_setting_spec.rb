require "spec_helper"

describe CompanySetting do
  before do
    stub_correios
  end

  describe "validations" do
    context "when valid resource" do
      it { ensure_length_of(:zipcode) }
      it { should validate_numericality_of(:zipcode) }
      it { should allow_value(96360000).for(:zipcode) }
      it { should allow_value(96360000).for(:zipcode) }
    end

    context "when invalid resource" do
      it { should_not allow_value(123).for(:zipcode) }
    end
  end

  before do
    @settings = FactoryGirl.create(:company_setting)
  end

  describe "hstore methods" do
    specify "#zipcode" do
      @settings.zipcode.should == 96360000

      @settings.zipcode         = 1234567
      @settings.zipcode.should == 1234567
    end

    specify "#store_theme" do
      @settings.store_theme.should == "overblue" # default store_theme

      @settings.store_theme         = "overblue2"
      @settings.save
      @settings.reload
      @settings.store_theme.should == "overblue2"

      @settings.store_theme         = nil
      @settings.save
      @settings.reload
      @settings.store_theme.should == "overblue"
    end
  end

  describe "valid_zipcode?" do
    it "returns true if there's a valid zipcode" do
      @settings.valid_zipcode?.should == true
    end

    it "adds an error message if there's not a valid zipcode" do
      ::ShippingCalculation::Correios::ZipcodeValidation
        .any_instance
        .stub(:invalid_origin_zipcode?) { true }

      @settings.errors.size.should == 0

      @settings.zipcode = 1237
      @settings.valid?

      @settings.errors.size.should_not == 0
    end
  end
end
