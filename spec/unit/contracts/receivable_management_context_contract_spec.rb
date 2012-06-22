shared_examples_for "ReceivablesManagementContext" do
  subject { ReceivablesManagementContext.new({}) }

  it "responds to save_receivable" do
    subject.should respond_to :save_receivable
  end

  it "responds to update_receivable" do
    subject.should respond_to :update_receivable
  end

  it "responds to delete_receivable" do
    subject.should respond_to :delete_receivable
  end
end
