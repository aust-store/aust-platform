# TODO unit test
require 'integration_spec_helper'

describe Admin::CustomersController do
  login_admin

  def form_attributes
    { first_name: "Jane", last_name: "Doe",description: "a new Customer" }
  end

  describe "GET index" do
    before do
      Customer.stub_chain(:within_company, :all).and_return(["customers"])
    end

    it "assigns all customers as @customers" do
      get :index
      assigns(:customers).should eq(["customers"])
    end
  end

  describe "GET show" do
    before do
      Customer.stub(:find).and_return("customer")
    end

    it "assigns the customer found by id" do
      get :show, id: 1
      assigns(:customer).should == "customer"
    end
  end

  describe "GET new" do
    before do
      Customer.stub(:new).and_return("customer")
    end

    it "assigns a new customer with company from current user" do
       get :new
       assigns(:customer).should == "customer"
    end
  end

  describe "POST create" do
    before do
      @customer = double and @customer.stub(:company=)
      Customer.stub(:new).and_return(@customer)
    end

    describe "with valid params" do
      before do
        @customer.should_receive(:save)
      end

      it "creates a new Customer" do
        post :create, { :customer => form_attributes }
      end
    end

    describe "with invalid params" do
      before do
         @customer.stub(:save).and_return(false)
      end

      it "assigns a new created customer as @customer" do
        post :create, { :good => {} }
        assigns(:customer).should == @customer
      end

      it "re-renders the 'new' template" do
        post :create, { :customer =>{} }
        response.should render_template(:new)
      end
    end
  end
end
