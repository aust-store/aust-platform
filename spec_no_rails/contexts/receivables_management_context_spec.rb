require "./spec_no_rails/spec_helper"
require "./app/roles/date_sanitizer"
require "./app/roles/currency_parser"
require "./spec_no_rails/contracts/simple_presenter_contract_spec"

require "./app/contexts/receivables_management_context"

class AccountReceivable; end
module Store; class Currency; end; end

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
  end

  describe ".save_receivable" do
    before do
      @resource = double
      @resource.stub(:customer_id=)
      @resource.stub(:admin_user_id=)
      @resource.stub(:save)

      @author = double
      Store::Currency.stub(:to_float).with("R$ 4,00").and_return(4.0)
      AccountReceivable.stub(:new).and_return(@resource)

      @context = ReceivablesManagementContext.new(valid_attributes, @author)
    end

    after do
      @context.save_receivable
    end

    it "should use injected params to instantiate data" do
      AccountReceivable.should_receive(:new).with(sanitized_attributes).and_return(@resource)
    end

    it "should set the customer" do
      @resource.should_receive(:customer_id=).with(123)
    end

    it "should set the admin user" do
      @resource.should_receive(:admin_user_id=).with(@author)
    end

  end
end
