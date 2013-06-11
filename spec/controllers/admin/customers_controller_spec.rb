require "spec_helper"

describe Admin::CustomersController do
  login_admin

  describe "GET #index" do
    it "assigns all customers as @customers" do
      controller.stub_chain(:current_company, :customers, :order, :page)
        .and_return(:customers)

      get :index
      assigns(:customers).should == :customers
    end
  end

  describe "GET #show" do
    let(:customers) { double }

    it "assigns the customer found by id" do
      controller.current_company.stub(:customers) { customers }
      customers.stub(:find).with("1") { :customers }

      get :show, id: 1
      assigns(:customer).should == :customers
    end
  end

  describe "GET #new" do
    it "assigns a new customer with company from current user" do
      Customer.stub(:new).with(company: controller.current_company) { :customer }
      get :new
      assigns(:customer).should == :customer
    end
  end

  describe "POST #create" do
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

  describe "GET #edit" do
    let(:customers) { double }

    it "assigns the customer found by id" do
      controller.current_company.stub(:customers) { customers }
      customers.stub(:find).with("1") { :customers }

      get :edit, id: 1
      assigns(:customer).should == :customers
    end
  end

  describe "PUT #update" do
    let(:customers) { double(find: customer) }
    let(:customer)  { double(update_attributes: nil) }

    before { controller.current_company.stub(:customers) { customers } }

    it "updates the customer's attributes" do
      customer.should_receive(:update_attributes).with("customer") { true }
      put :update, id: '1', customer: :customer
    end

    context "when the attributes are successfully updated" do
      before { customer.stub(update_attributes: true) }

      it "redirects to the admin_customer_url" do
        put :update, id: '1'
        response.should redirect_to admin_customer_url(customer)
      end
    end

    context "when the attributes are not updated" do
      before { customer.stub(update_attributes: false) }

      it "redirects to the admin_customer_url" do
        put :update, id: '1'
        response.should render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    let(:customer)  { double }
    let(:customers) { double(find: customer) }

    before { controller.current_company.stub(:customers) { customers } }

    it "destroys the customer" do
      customer.should_receive(:destroy)
      delete :destroy, id: 1
    end

    it "redirects to the admin_customer_path" do
      customer.stub(:destroy)
      delete :destroy, id: 1
      response.should redirect_to admin_customers_url
    end
  end
end
