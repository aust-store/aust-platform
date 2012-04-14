require 'spec_helper'

describe Admin::CustomersController do
  login_admin


  before do
    @customer = Factory(:customer)
    @customer_from_other_company = Factory(:customer,company_id: 2)
  end

  def form_attributes
    {first_name: "Jane", last_name: "Doe",description: "a new Customer"}
  end

  describe "GET index" do
    it "assigns all customers as @customers" do
      get :index
      assigns(:customers).should eq([@customer])
      assigns(:customers).should_not include(@customer_from_other_company)
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
    it "assigns a new customer with company from current user" do
       get :new
       assigns(:customer).should be_a_kind_of(Customer)
       assigns(:customer).company_id.should eq(@admin_user.company.id)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Customer" do
        expect {
          post :create, {:customer => form_attributes}
        }.to change(Customer,:count).by(1)
      end

      it "assigns a newly created customer as @customer" do
        post :create,  {:customer => form_attributes}
        assigns(:customer).should be_a(Customer)
        assigns(:customer).should be_persisted
        assigns(:customer).company_id.should eq(@admin_user.company.id)
      end
    end

    describe "with invalid params" do
      before do
         Customer.any_instance.stub(:save).and_return(false)
      end

      it "assigns a new created customer as @customer" do
        post :create, {:good => {}}
        assigns(:customer).should be_a_new(Customer)
      end

      it "re-renders the 'new' template" do
        post :create, {:customer =>{}}
        response.should render_template(:new)
      end
    end
  end
end
