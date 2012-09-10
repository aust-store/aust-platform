require "store/customer_creation"

describe Store::CustomerCreation do
  let(:controller) { double(current_company: company) }
  let(:company)    { double(customers: customers) }
  let(:customers)  { double }
  let(:model_instance) { double(save: true) }

  describe "#create" do
    it "creates a user" do
      model_instance.should_receive(:save)
      customers.stub(:new).with(:data) { model_instance }

      Store::CustomerCreation.new(controller).create(:data)
    end

    it "returns the result from the creation" do
      customers.stub(:new) { double(save: :return_from_the_model) }

      customer = Store::CustomerCreation.new(controller).create(:data)
      customer.should == :return_from_the_model
    end
  end
end
