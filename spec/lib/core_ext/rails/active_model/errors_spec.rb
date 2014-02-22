require "spec_helper"

describe ActiveModel::Errors do
  describe "#first_messages" do
    it "returns only the first error messages" do
      customer = Person.new(environment: "website")
      customer.valid?
      customer.errors.messages[:social_security_number].size.should == 1
      customer.errors.first_messages[:social_security_number].size.should == 1

      first_message = customer.errors.messages[:social_security_number].first
      customer.errors.first_messages[:social_security_number].first.should == first_message
    end
  end
end
