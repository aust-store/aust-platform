class Customer; end

require "store/customer_creation"

describe Store::CustomerCreation do
  subject { described_class }

  it "delegates to Customer the persistence of a new customer" do
    data = double
    company = double
    customer = double
    Customer.should_receive(:new).with(data) { customer }
    customer.should_receive(:company=).with(company)
    customer.should_receive(:save)
    Store::CustomerCreation.create(data, company)
  end
end
