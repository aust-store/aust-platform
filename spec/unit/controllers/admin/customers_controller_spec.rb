require "unit_spec_helper"
require "controllers/admin/customers_controller"

class Customer; end
module Store; class CustomerCreation; end; end

describe Admin::CustomersController do
  subject { described_class.new}

  it_obeys_the "Customer contract"
  it_obeys_the "CustomerCreation contract"

  before do
    @customers = double
    subject.stub_chain(:current_user, :company) { 1 }
  end

  describe "#index" do
    it "assigns all customers as @customers" do
      Customer.stub(:within_company).with(1) { double(all: @customers) }
      subject.index.should == @customers
    end
  end

  describe "#show" do
    it "assigns the customer found by id" do
      subject.stub(:params) { {id: 1} }
      Customer.stub(:find).with(1) { @customers }
      subject.show.should == @customers
    end
  end

  describe "#new" do
    it "assigns a new customer with company from current user" do
      Customer.stub(:new).with(company: 1) { @customers }
      subject.new.should == @customers
    end
  end

  describe "#create" do
    before do
      subject.stub(:params) { {customer: :customer} }
      Store::CustomerCreation.stub(:create) { @customer }
    end

    it "delegates the customer creation" do
      Store::CustomerCreation.should_receive(:create)
                             .with(:customer, 1)
      subject.create
    end

    it "should redirect to customers when saved successfuly" do
      Store::CustomerCreation.stub(:create) { true }
      subject.stub(:admin_customers_url) { :my_url }
      subject.should_receive(:redirect_to).with(:my_url)
      subject.create
    end

    it "should render the form when not saving successfuly" do
      Store::CustomerCreation.stub(:create) { false }
      subject.should_receive(:render).with("new")
      subject.create
    end
  end
end
