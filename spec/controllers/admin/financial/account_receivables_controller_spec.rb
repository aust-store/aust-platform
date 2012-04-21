require 'spec_helper'

describe Admin::Financial::AccountReceivablesController do
  login_admin

  let(:valid_attributes) do
    { "description" => "These came from Japan.",
      "value"       => "R$ 4,00",
      "due_to"      => "21/04/2012" }
  end
  
  let(:sanitized_attributes) do
    { "description" => "These came from Japan.",
      "value"       => 4.0,
      "due_to"      => "2012/04/21" }
  end

  before do
    @context = double
  end

  describe "POST create" do
    it "should redirect to the main page if saved resource" do
      @context.stub(:save_receivable).and_return(true)
      ReceivablesManagementContext.stub(:new).and_return(@context)
      post :create, { customer_id: "1", account_receivable: valid_attributes }
      response.should redirect_to(admin_customer_account_receivables_path)
    end

    it "should render the form again if didn't save resource" do
      @context.stub(:save_receivable).and_return(false)
      @context.stub(:resource).and_return("resource")
      ReceivablesManagementContext.stub(:new).and_return(@context)
      post :create, { customer_id: "1", account_receivable: valid_attributes }
      response.should render_template("new")
      assigns(:receivable).should == "resource"
    end
  end
end
