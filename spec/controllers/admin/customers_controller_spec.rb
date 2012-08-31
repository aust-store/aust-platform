require "spec_helper"

describe Admin::CustomersController do
  login_admin

  #it_obeys_the "Customer contract"
  #it_obeys_the "CustomerCreation contract"

  describe "GET index" do
    it "assigns all customers as @customers" do
      customers = double
      Customer.stub(:within_company)
              .with(1)
              .and_return(double(all: customers))

      get :index
      assigns(:customers).should == customers
    end
  end

  describe "GET show" do
    it "assigns the customer found by id" do
      Customer.stub(:find).with("1") { :customers }
      get :show, id: 1
      assigns(:customer).should == :customers
    end
  end

  describe "GET new" do
    it "assigns a new customer with company from current user" do
      Customer.stub(:new).with(company: 1) { :customer }
      get :new
      assigns(:customer).should == :customer
    end
  end

  describe "POST create" do
    before do
      subject.stub(:params) { {customer: :customer} }
      Store::CustomerCreation.stub(:create) { @customer }
    end

    it "delegates the customer creation" do
      Store::CustomerCreation.should_receive(:create)
                             .with(:customer, 1)
      post :create, customer: :customer
    end

    it "redirect to customers when saved successfuly" do
      Store::CustomerCreation.stub(:create) { double }
      post :create, customer: :customer
      response.should redirect_to admin_customers_url
    end

    it "render the form when not saving successfuly" do
      Store::CustomerCreation.stub(:create) { false }
      post :create, customer: :customer
      response.should render_template "new"
    end
  end
end
