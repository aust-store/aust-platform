require "active_support/all"
require "store/policy/company/banners"

describe Store::Policy::Company::Banners do
  let(:company) { double(banners: banners) }
  let(:banners) do
    [ double(position: "all_pages_right"),
      double(position: "all_pages_right"),
      double(position: "all_pages_right") ]
  end

  subject { described_class.new(company) }

  describe "#eligible?" do
    context "position provided" do
      it "returns true if position has available slots" do
        subject.stub(:max_banners) { {all_pages_right: 5} }
        subject.eligible?(:all_pages_right).should be_true
      end

      it "returns false if position doesn't have available slots" do
        subject.eligible?(:all_pages_right).should be_false
      end
    end

    context "position not provided" do
      it "returns true if any position has available slots" do
        subject.eligible?.should be_true
      end

      it "returns false if no position have available slots" do
        subject.eligible?(:all_pages_right).should be_false
      end
    end
  end
end
