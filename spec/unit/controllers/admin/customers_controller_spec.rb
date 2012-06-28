require "unit_spec_helper"
require "controllers/admin/customers_controller"

class Customer; end

describe Admin::CustomersController do
  subject { described_class.new}

  it_obeys_the "Customer contract"

  before do
    @customers = double
  end

  describe "#index" do
    it "assigns all customers as @customers" do
      subject.stub_chain(:current_user, :company) { 1 }
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
      subject.stub_chain(:current_user, :company) { 1 }
      Customer.stub(:new).with(company: 1) { @customers }
      subject.new.should == @customers
    end
  end

  describe "#create" do
    before do
      @customer = double and @customer.stub(:company=)
      Customer.stub(:new) { @customer }
      subject.stub_chain(:current_user, :company) { 1 }
    end

    it "should redirect to customers when saved successfuly" do
      @customer.stub(:save) { true }
      subject.stub(:admin_customers_url) { :my_url }
      subject.should_receive(:redirect_to).with(:my_url)
      subject.create
    end

    it "should render the form when not saving successfuly" do
      @customer.stub(:save) { false }
      subject.should_receive(:render).with("new")
      subject.create
    end
  end
end
