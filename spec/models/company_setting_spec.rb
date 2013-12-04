require "spec_helper"

describe CompanySetting do
  subject { build(:company_setting) }

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

  describe "hstore methods" do
    specify "#zipcode" do
      subject.zipcode.should == 96360000

      subject.zipcode         = 1234567
      subject.zipcode.should == 1234567
    end
  end

  describe "valid_zipcode?" do
    it "returns true if there's a valid zipcode" do
      subject.valid_zipcode?.should == true
    end

    it "adds an error message if there's not a valid zipcode" do
      ::ShippingCalculation::Correios::ZipcodeValidation
        .any_instance
        .stub(:invalid_origin_zipcode?) { true }

      subject.errors.size.should == 0

      subject.zipcode = 1237
      subject.valid?

      subject.errors.size.should_not == 0
    end
  end

  describe "#sales_enabled" do
    context "value is nil (not defined)" do
      it "returns true" do
        subject.sales_enabled = nil
        subject.sales_enabled.should === true
      end
    end

    context "value in database is '1'" do
      it "returns true" do
        subject.sales_enabled = "1"
        subject.sales_enabled.should === true
      end
    end

    context "value in database is '0'" do
      it "returns false" do
        subject.sales_enabled = "0"
        subject.sales_enabled.should === false
      end
    end
  end
end
