require "spec_helper"

describe Admin::CustomersController do
  login_admin

  #it_obeys_the "Customer contract"
  #it_obeys_the "CustomerCreation contract"

  describe "GET index" do
    it "assigns all customers as @customers" do
      controller.stub_chain(:current_company, :customers, :all)
        .and_return(:customers)

      get :index
      assigns(:customers).should == :customers
    end
  end

  describe "GET show" do
    let(:customers) { double }

    it "assigns the customer found by id" do
      controller.current_company.stub(:customers) { customers }
      customers.stub(:find).with("1") { :customers }

      get :show, id: 1
      assigns(:customer).should == :customers
    end
  end

  describe "GET new" do
    it "assigns a new customer with company from current user" do
      Customer.stub(:new).with(company: controller.current_company) { :customer }
      get :new
      assigns(:customer).should == :customer
    end
  end

  describe "POST create" do
    let(:customer) { double }

    before do
      Store::CustomerCreation.stub(:new).with(controller) { customer }
    end

    it "delegates the customer creation" do
      customer.should_receive(:create).with("customer") { true }
      post :create, customer: :customer
    end

    it "redirect to customers when saved successfuly" do
      customer.stub(:create).with("customer") { true }

      post :create, customer: :customer
      response.should redirect_to admin_customers_url
    end

    it "render the form when not saving successfuly" do
      customer.stub(:create).with("customer") { false }
      customer.stub(:ar_instance) { :active_record_instance }

      post :create, customer: :customer
      response.should render_template "new"
      assigns(:customer).should == :active_record_instance
    end
  end
end