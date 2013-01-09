require 'spec_helper'

describe ShippingBox do
  describe "validations" do
    context "when valid resource" do
      it { should allow_value(11) .for(:width) }
      it { should allow_value(105).for(:width) }

      it { should allow_value(18) .for(:length) }
      it { should allow_value(105).for(:length) }

      it { should allow_value(2)  .for(:height) }
      it { should allow_value(105).for(:height) }

      it { should allow_value(0.3).for(:weight) }
      it { should allow_value(30) .for(:weight) }
    end

    context "when invalid resource" do
      it { should_not allow_value(10) .for(:width) }
      it { should_not allow_value(106).for(:width) }

      it { should_not allow_value(17) .for(:length) }
      it { should_not allow_value(106).for(:length) }

      it { should_not allow_value(1)  .for(:height) }
      it { should_not allow_value(106).for(:height) }

      it { should_not allow_value(0.2).for(:weight) }
      it { should_not allow_value(106).for(:weight) }
    end

    describe "dependent_fields_present?" do
      let(:shipping_box) { ShippingBox.new({ height: 10,
                                             weight: 12,
                                             width:  23,
                                             length: 19 })
                         }

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

      it "should return false when some attribute is left blank" do
        shipping_box.weight = nil
        shipping_box.should_not be_valid
      end
    end
  end
end