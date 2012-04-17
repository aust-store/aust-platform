require "./spec_no_rails/spec_helper"
require "./app/presenters/admin/receivable_presenter"

describe Admin::ReceivablePresenter do
  def attributes
    { due_to: Time.new(2012, 04, 21, 12, 12, 12) }
  end

  before do
    @resource = double
  end

  describe ".value" do
    it "should return as currency" do
      @resource.stub(:value)
      @presenter = Admin::ReceivablePresenter.new @resource
      @presenter.should_receive(:to_currency).and_return "R$ 50,40"
      @presenter.value.should == "R$ 50,40"
    end
  end

  describe ".due_to" do
    it "should return a valid date" do
      @resource.stub(:due_to).and_return(attributes[:due_to])
      @presenter = Admin::ReceivablePresenter.new @resource
      @presenter.due_to.should == "21/04/2012"
    end
  end

  describe ".status" do
    it "should return paid" do
      @resource.stub(:paid?).and_return(true)
      @presenter = Admin::ReceivablePresenter.new @resource
      @presenter.status.should == "pago"
    end

    it "should return as due" do
      @resource.stub(:paid?).and_return(false)
      @presenter = Admin::ReceivablePresenter.new @resource
      @presenter.status.should == "pendente"
    end
  end
end
