# TODO unit test
require 'spec_helper'

describe Customer do
  describe "customer instances methods" do
    before do
      @customer = Customer.new first_name: "Jane", last_name: "Doe"
    end

    it "should result the first_name plus last_name" do
      @customer.name.should eql("Jane Doe")
    end

  end
end
