require "store/online_sales/reason_for_item_not_on_sale"

describe Store::OnlineSales::ReasonForItemNotOnSale do
  let(:requirements) { double }
  let(:item)         { double }

  subject { described_class.new(item) }

  before do
    stub_const("Store::OnlineSales::ItemRequirementsForSale", Class.new)
    Store::OnlineSales::ItemRequirementsForSale.stub(:new) { requirements }

    requirements.stub(:has_price?)         { true }
    requirements.stub(:has_entry_on_sale?) { true }
    requirements.stub(:has_cover_image?)   { true }
    requirements.stub(:has_shipping_box?)  { true }
  end

  describe "#reasons" do
    describe "item's price" do
      it "returns array with :has_no_price if item has no price" do
        requirements.stub(:has_price?) { false }
        subject.reasons.should == [:has_no_price]
      end

      it "doesn't return array with :has_no_price if item has price" do
        requirements.stub(:has_price?) { true }
        subject.reasons.should == []
      end
    end

    describe "item's entries for sale" do
      it "returns array with :has_no_entry_on_sale if item has no entry for sale" do
        requirements.stub(:has_entry_on_sale?) { false }
        subject.reasons.should == [:has_no_entry_on_sale]
      end

      it "doesn't return array with :has_no_entry_on_sale if item has entry for sale" do
        requirements.stub(:has_no_entry_on_sale?) { true }
        subject.reasons.should == []
      end
    end

    describe "item's cover image" do
      it "returns array with :has_no_cover_image if item has no cover image" do
        requirements.stub(:has_cover_image?) { false }
        subject.reasons.should == [:has_no_cover_image]
      end

      it "doesn't return array with :has_no_cover_image if item has cover image" do
        requirements.stub(:has_cover_image?) { true }
        subject.reasons.should == []
      end
    end

    describe "item's shipping box" do
      it "returns array with :has_no_shipping_box if item has no shipping box" do
        requirements.stub(:has_shipping_box?) { false }
        subject.reasons.should == [:has_no_shipping_box]
      end
      it "doesn't return array with :has_no_shipping_box if item has shipping box" do
        requirements.stub(:has_shipping_box?) { true }
        subject.reasons.should == []
      end
    end
  end
end
