require "decorators/admin/account_receivable_decorator"

shared_examples_for "admin account receivable decorator contract" do
  subject { Admin::AccountReceivableDecorator }

  it "decorates account receivable" do
    expect do
      subject.decorated_collection.should include [ :account_receivable ]
    end.to_not raise_error
  end

  it "allows description" do
    expect do
      subject.allowed_collection.should == [
        :id, :description, :value, :due_to, :paid, :created_at,
        :customer, :errors
      ]
    end.to_not raise_error
  end
end
