require "spec_helper"

describe ReceivablesManagementContext do

  let(:valid_attributes) do
    { account_receivable:
      { "description" => "These came from Japan.",
        "value"       => "R$ 4,00",
        "due_to"      => "21/04/2012" },
      :customer_id => 123
    }
  end

  let(:sanitized_attributes) do
    { "description" => "These came from Japan.",
      "value"       => "4.0",
      "due_to"      => "2012/04/21" }
  end

  before do
    Store::Currency.stub(:to_float).with("R$ 4,00").and_return(4.0)
    @resource = double
    AccountReceivable.stub(:find).and_return(@resource)
  end

  describe ".save_receivable" do
    before do
      @resource.stub(:customer_id=)
      @resource.stub(:admin_user_id=)
      @resource.stub(:save)

      @author = double
      AccountReceivable.stub(:new).and_return(@resource)

      @context = ReceivablesManagementContext.new(valid_attributes, @author)
    end

    after do
      @context.save_receivable
    end

    it "uses injected params to instantiate data" do
      AccountReceivable.should_receive(:new).with(sanitized_attributes).and_return(@resource)
    end

    it "sets the customer" do
      @resource.should_receive(:customer_id=).with(123)
    end

    it "sets the admin user" do
      @resource.should_receive(:admin_user_id=).with(@author)
    end
  end

  describe ".update_receivable" do
    before do
      @context = ReceivablesManagementContext.new(valid_attributes)
    end

    it "uses injected params to instantiate data" do
      @resource.should_receive(:update_attributes).with(valid_attributes[:account_receivable])
      @context.update_receivable
    end
  end
  
  describe ".delete_receivable" do
    before do
      @context = ReceivablesManagementContext.new(valid_attributes.merge(id: "2"))
    end

    it "uses injected params to instantiate data" do
      AccountReceivable.should_receive(:destroy).with("2")
      @context.delete_receivable
    end
  end
end
