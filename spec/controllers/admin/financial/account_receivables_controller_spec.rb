require 'spec_helper'

describe Admin::Financial::AccountReceivablesController do
  login_admin

  it_obeys_the "Receivables Management context contract"

  describe "GET index" do
    it "assigns decorated receivables" do
      Admin::AccountReceivableDecorator.stub(:decorate) { :decorated }
      get :index
      assigns(:receivables).should == :decorated
    end
  end

  describe "GET new" do
    it "assigns decorated receivables" do
      Admin::AccountReceivableDecorator.stub(:decorate) { :decorated }
      get :new, customer_id: "1"
      assigns(:receivable).should == :decorated
    end
  end

  describe "GET edit" do
    it "assigns decorated receivables" do
      Admin::AccountReceivableDecorator.stub(:decorate) { :decorated }
      get :new, customer_id: "1", id: "1"
      assigns(:receivable).should == :decorated
    end
  end

  describe "POST create" do
    it "should redirect to the main page if saved resource" do
      ReceivablesManagementContext.stub(:new) { double(save_receivable: true) }

      post :create, customer_id: "1", id: "1", account_receivable: "data"
      response.should redirect_to admin_customer_account_receivables_path
    end

    context "when no receivable is saved" do
      it "assigns the decorated resource" do
        ReceivablesManagementContext.stub(:new) do
          double(save_receivable: false, resource: :resource)
        end

        Admin::AccountReceivableDecorator.stub(:decorate)
          .with(:resource).and_return(:decorated)

        post :create, account_receivable: "data"
        assigns(:receivable).should == :decorated
      end

      it "renders the form again if didn't save resource" do
        ReceivablesManagementContext.stub(:new) do
          double(save_receivable: false, resource: :resource)
        end

        Admin::AccountReceivableDecorator.stub(:decorate)

        post :create, account_receivable: "data"
        response.should render_template "new"
      end
    end
  end

  describe "PUT update" do
    before do
      ReceivablesManagementContext.stub(:new).and_return(@context)
    end

    it "should redirect to the main page if saved resource" do
      ReceivablesManagementContext.stub(:new) { double(update_receivable: true) }

      put :update, customer_id: "1", id: "1", account_receivable: "data"
      response.should redirect_to admin_customer_account_receivables_url
    end

    context "invalid resource" do
      it "renders the form again if didn't save resource" do
        ReceivablesManagementContext.stub(:new) do
          double(update_receivable: false, resource: :resource)
        end

        Admin::AccountReceivableDecorator.stub(:decorate)

        put :update, customer_id: "1", id: "1", account_receivable: "data"
        response.should render_template "edit"
      end

      it "instantiates the resource from the context" do
        ReceivablesManagementContext.stub(:new) do
          double(update_receivable: false, resource: :resource)
        end

        Admin::AccountReceivableDecorator.stub(:decorate)
          .with(:resource).and_return(:decorated)

        put :update, customer_id: "1", id: "1", account_receivable: "data"
        assigns(:receivable).should == :decorated
      end
    end
  end

  describe "DELETE destroy" do
    let(:context) { double }

    it "deletes the receivable" do
      ReceivablesManagementContext.stub(:new) { context }
      context.should_receive(:delete_receivable)

      delete :destroy, customer_id: "1", id: "1"
    end

    it "renders the form again if didn't save resource" do
      ReceivablesManagementContext.stub(:new) { context }
      context.stub(:delete_receivable)

      delete :destroy, customer_id: "1", id: "1"
      response.should redirect_to admin_customer_account_receivables_url
    end
  end
end
