require 'spec_helper'

describe Customer do
  describe "customer instances methods" do
    before do
      @customer = Factory(:customer)
    end

    it "should result the first_name plus last_name" do
      @customer.name.should eql("Jane Doe")
    end

    end
end
