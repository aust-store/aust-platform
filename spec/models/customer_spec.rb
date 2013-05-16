require 'spec_helper'

describe Customer do

  describe "associations" do
    it { should belong_to :company }
  end

  describe "validations" do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :company }
  end

  describe "#name" do
    it "should result the first_name plus last_name" do
      customer = Customer.new(first_name: "Jane", last_name: "Doe")
      customer.name.should eql "Jane Doe"
    end
  end
end
