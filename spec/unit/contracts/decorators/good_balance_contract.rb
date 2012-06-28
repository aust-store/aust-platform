class Good < ActiveRecord::Base; class Balance; end; end

require "decorators/admin/good_balance_decorator"

shared_examples_for "admin good balance decorator contract" do
  subject { Admin::GoodBalanceDecorator }

  it "decorates good_balance" do
    expect do
      subject.decorated_collection.should include [
        :good_balance, { class: Good::Balance }
      ]
    end.to_not raise_error
  end

  it "allows description" do
    expect do
      subject.allowed_collection.should == [
        :description, :quantity, :cost_per_unit, :total_quantity, :total_cost,
        :created_at
      ]
    end.to_not raise_error
  end
end
