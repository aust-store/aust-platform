require 'spec_helper'

describe Admin::Financial::AccountReceivablesController do
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
    subject.stub(:current_admin_user)
    subject.stub(:admin_customer_account_receivables_path) { "receivables" }
  end

  pending "#create" do
    before do
      ReceivablesManagementContext.stub(:new).and_return(@context)
    end

    it "should redirect to the main page if saved resource" do
      @context.stub(:save_receivable) { true }

      subject.should_receive(:redirect_to)
             .with("receivables", notice: "Conta a receber cadastrada.")
      subject.create
    end

    it "should render the form again if didn't save resource" do
      @context.stub(:save_receivable) { false }
      @context.stub(:resource).and_return("resource")

      subject.should_receive(:decorate).with("resource")
      subject.should_receive(:render).with(:new)
      subject.create
    end
  end

  pending "#update" do
    before do
      ReceivablesManagementContext.stub(:new).and_return(@context)
    end

    it "should redirect to the main page if saved resource" do
      @context.stub(:update_receivable) { true }
      subject.should_receive(:redirect_to)
             .with("receivables", notice: "Conta a receber salva.")
      subject.update
    end

    context "invalid resource" do
      before do
        @context.stub(:update_receivable) { false }
        @context.stub(:resource) { "resource" }
      end

      it "should render the form again if didn't save resource" do
        subject.stub(:decorate)

        subject.should_receive(:render).with(:edit)
        subject.update
      end

      it "should instantiate the resource from the context" do
        subject.should_receive(:decorate).with("resource")
        subject.update
      end
    end
  end

  pending "#destroy" do
    before do
      @context.stub(:delete_receivable)
      ReceivablesManagementContext.stub(:new).and_return(@context)
    end

    it "should delete the receivable" do
      @context.should_receive(:delete_receivable)
      subject.destroy
    end

    it "should render the form again if didn't save resource" do
      subject.should_receive(:redirect_to)
             .with("receivables", notice: "Conta a receber salva.")
      subject.destroy
    end
  end
end
