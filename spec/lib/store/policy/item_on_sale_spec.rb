require "store/online_sales/reason_for_item_not_on_sale"
require "store/policy/item_on_sale"
require "store/online_sales/item_requirements_for_sale"
require "active_support/all"

describe Store::Policy::ItemOnSale do
  let(:item) { double }

  subject { described_class.new(item) }

  describe "#on_sale?" do
    before do
      stub_const("Store::ItemPrice", Class.new)
      Store::ItemPrice.stub_chain(:new, :price) { 10 }
      item.stub_chain(:images, :has_cover?) { true }
      item.stub(:entry_for_website_sale) { 3 }
      item.stub(:shipping_box) { double }
    end

    context "when it's on sale" do
      it "returns true if item has requirements to be on sale" do
        expect(subject).to be_on_sale
      end
    end

    context "when it's not on sale" do
      after do
        expect(subject).to_not be_on_sale
      end

      it "returns false when it has no price defined" do
        Store::ItemPrice.stub_chain(:new, :price) { nil }
      end

      it "returns false when it has no entry on sale defined" do
        item.stub(:entry_for_website_sale) { nil }
      end

      it "returns false when it has no cover image" do
        item.stub_chain(:images, :has_cover?) { false }
      end

      it "returns false when it has no shipping box" do
        item.stub(:shipping_box) { nil }
      end
    end
  end
end
