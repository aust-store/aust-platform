require "store/policy/point_of_sale"

describe Store::Policy::PointOfSale do
  let(:company) { double }

  subject { described_class.new(company) }

  describe "#enabled?" do
    it "returns true" do
      expect(subject).to be_enabled
    end
  end
end
