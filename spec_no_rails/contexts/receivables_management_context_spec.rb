require "./spec_no_rails/spec_helper"
require "./app/roles/date_sanitizer"
require "./spec_no_rails/contracts/simple_presenter_contract_spec"

require "./app/contexts/receivables_management_context"

class AccountReceivable; end
module Store; class Currency; end; end

describe ReceivablesManagementContext do

  let(:valid_attributes) do
    { account_receivable:
      { "description" => "These came from Japan.",
        "value"       => "R$ 4,00",
        "due_to"      => "21/04/2012" }
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
      @params = { account_receivable: :value }
      @data = double
      @data.stub(:customer_id=)
      @data.stub(:save)
    end

    it "should use injected params to instantiate data" do
      Store::Currency.stub(:to_float).with("R$ 4,00").and_return(4.0)
      @context = ReceivablesManagementContext.new(valid_attributes)
      AccountReceivable.should_receive(:new).with(sanitized_attributes).and_return(@data)
      @context.save_receivable
    end

  end
end
