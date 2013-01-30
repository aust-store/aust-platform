require 'spec_helper'

describe ShippingBox do
  describe "validations" do
    context "when valid resource" do
      it { should allow_value(11) .for(:width)  }
      it { should allow_value(105).for(:width)  }

      it { should allow_value(18) .for(:length) }
      it { should allow_value(105).for(:length) }

      it { should allow_value(2)  .for(:height) }
      it { should allow_value(105).for(:height) }

      it { should allow_value(0.3).for(:weight) }
      it { should allow_value(30) .for(:weight) }
    end

    context "when invalid resource" do
      it { should_not allow_value(10) .for(:width)  }
      it { should_not allow_value(106).for(:width)  }

      it { should_not allow_value(17) .for(:length) }
      it { should_not allow_value(106).for(:length) }

      it { should_not allow_value(1)  .for(:height) }
      it { should_not allow_value(106).for(:height) }

      it { should_not allow_value(0.2).for(:weight) }
      it { should_not allow_value(106).for(:weight) }
    end

    describe "dependent_fields_present?" do
      let(:shipping_box) { ShippingBox.new(height: 10, weight: 12, width: 23, length: 19) }

      it "should return true if all attributes are present" do
        shipping_box.should be_valid
      end

      it "should return true when all attributes are left blank" do
        shipping_box.weight = nil
        shipping_box.length = nil
        shipping_box.width  = nil
        shipping_box.height = nil

        shipping_box.should be_valid
      end

      it "should return false when any 2 attributes has been left blank" do
        shipping_box.weight = nil
        shipping_box.height = nil
        shipping_box.should_not be_valid
      end

      it "should return false when only weight attribute is left blank" do
        shipping_box.weight = nil
        shipping_box.should_not be_valid
      end

      it "should return false when only length is left blank" do
        shipping_box.length = nil
        shipping_box.should_not be_valid
      end

      it "should return false when only width attribute is left blank" do
        shipping_box.width = nil
        shipping_box.should_not be_valid
      end

      it "should return false when only height attribute is left blank" do
        shipping_box.height = nil
        shipping_box.should_not be_valid
      end
    end

    describe "calculate_total_dimensions" do
      let(:shipping_box) { ShippingBox.new(height: 50, weight: 20, width: 50, length: 100) }

      it "should return true if the 3d sum total is equal or less than 200" do
        shipping_box.length = 100
        shipping_box.width  = 50
        shipping_box.height = 50

        shipping_box.calculate_total_dimensions.should == true
      end

      it "should add an error message if the 3d sum total is greater than 200" do
        shipping_box.errors.size.should == 0

        shipping_box.length = 100
        shipping_box.width  = 50
        shipping_box.height = 51

        shipping_box.calculate_total_dimensions
        shipping_box.errors.size.should == 1
      end
    end
  end
end