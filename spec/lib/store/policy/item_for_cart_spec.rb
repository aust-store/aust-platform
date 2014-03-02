require "store/policy/item_for_cart"
require "active_support/all"

describe Store::Policy::ItemForCart do
  let(:company)      { double(sales_enabled?: true) }
  let(:shipping_box) { double(valid?: true) }
  let(:item)         { double(company: company, shipping_box: shipping_box) }

  before do
    stub_const("OnlineSales::ReasonForItemNotForCart", Class.new)
  end

  subject { described_class.new(item) }

  describe "#valid?" do
    it "returns true" do
      subject.should be_valid
    end

    context "global sales are disabled" do
      before { company.stub(:sales_enabled?) }
      its(:valid?) { should be_false }
    end

    context "shipping box is invalid" do
      before { shipping_box.stub(:valid?) }
      its(:valid?) { should be_false }
    end
  end
end
