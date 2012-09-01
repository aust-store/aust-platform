require "./app/contexts/receivables_management_context"

shared_examples_for "Receivables Management context contract" do
  subject { ReceivablesManagementContext.new(double.as_null_object) }

  before do
    stub_const("AccountReceivable", Object.new)
    subject.stub(:sanitize_controller_params)
    @resource = double.as_null_object
  end

  describe "#save_receivable" do
    before do
      AccountReceivable.stub(:new) { @resource }
    end

    it "responds to save_receivable if no parameters" do
      expect do
        subject.save_receivable
      end.to_not raise_error
    end
  end

  describe "#update_receivable" do
    before do
      AccountReceivable.stub(:find) { @resource }
    end

    it "responds to update_receivable if no parameters" do
      expect do
        subject.update_receivable
      end.to_not raise_error
    end
  end

  describe "#delete_receivable" do
    it "responds to delete_receivable without arguments" do
      AccountReceivable.stub(:destroy)

      expect do
        subject.delete_receivable
      end.to_not raise_error
    end
  end
end
