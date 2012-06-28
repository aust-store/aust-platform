require 'unit_spec_helper'

require "decorators/admin/account_receivable_decorator"

describe Admin::AccountReceivableDecorator do
  it_obeys_the "admin account receivable decorator contract"

  def attributes
    { due_to: Time.new(2012, 04, 21, 12, 12, 12) }
  end

  before do
    @resource = double.as_null_object
    @presenter = Admin::AccountReceivableDecorator.new @resource

    @presenter.stub(:account_receivable) { @resource }
  end

  describe ".value" do
    it "should return as currency" do
      @resource.stub(:value)
      @presenter.should_receive(:to_currency).and_return "R$ 50,40"
      @presenter.value.should == "R$ 50,40"
    end
  end

  describe "#due_to" do
    it "should return a valid date" do
      @resource.stub(:due_to).and_return(attributes[:due_to])
      @presenter.due_to.should == "21/04/2012"
    end
  end

  describe "#status" do
    it "should return paid" do
      @resource.stub(:paid?).and_return(true)
      @presenter.status.should == "pago"
    end

    it "should return as due" do
      @resource.stub(:paid?).and_return(false)
      @presenter.status.should == "pendente"
    end
  end
end
