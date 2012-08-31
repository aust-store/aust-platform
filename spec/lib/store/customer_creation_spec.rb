require "store/customer_creation"

describe Store::CustomerCreation do
  it "delegates to Customer the persistence of a new customer" do
    customer_model = double
    customer = double
    data = double
    company = double
    customer_model.should_receive(:new).with(data) { customer }
    customer.should_receive(:company_id=).with(company)
    customer.should_receive(:save)
    Store::CustomerCreation.create(data, company, customer_model)
  end
end
