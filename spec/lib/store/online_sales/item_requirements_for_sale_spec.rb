require "store/online_sales/item_requirements_for_sale"
require "active_support/all"

describe Store::OnlineSales::ItemRequirementsForSale do
  let(:item) { double }
  let(:item_price) { double }

  subject { described_class.new(item) }

  before do
    stub_const("Store::ItemPrice", item_price)
  end

  describe "#has_price?" do
    it "returns true when it has price defined" do
      item_price.stub_chain(:new, :price) { 12 }
      subject.has_price?.should be_true
    end

    it "returns false when it has no price defined" do
      item_price.stub_chain(:new, :price) { nil }
      subject.has_price?.should be_false
    end
  end

  describe "#has_entry_on_sale?" do
    it "returns true when it has entry on sale defined" do
      item.stub(:entry_for_website_sale) { true }
      subject.has_entry_on_sale?.should == true
    end

    it "returns false when it has no entry on sale defined" do
      item.stub(:entry_for_website_sale) { nil }
      subject.has_entry_on_sale?.should == false
    end
  end

  describe "#has_cover_image?" do
    it "returns true when it has cover image" do
      item.stub_chain(:images, :has_cover?) { true }
      subject.has_cover_image?.should be_true
    end

    it "returns false when it has no cover image" do
      item.stub_chain(:images, :has_cover?) { false }
      subject.has_cover_image?.should be_false
    end
  end

  describe "#has_shipping_box?" do
    it "returns true when it has shipping box" do
      item.stub(:shipping_box) { [:shipping_box] }
      subject.has_shipping_box?.should be_true
    end

    it "returns false when it has no shipping box" do
      item.stub(:shipping_box) { nil }
      subject.has_shipping_box?.should be_false
    end
  end
end
