require 'spec_helper'

describe PaymentStatus do
  describe "#set_status_as" do
    it "sets to approved" do
      status = described_class.new(order_id: 1)
      status.set_status_as(:approved)
      saved_status = described_class.last
      saved_status.status.should == "approved"
    end
  end
end
