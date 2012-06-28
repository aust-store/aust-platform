require 'integration_spec_helper'

describe "Draper decorator contract" do
  subject { ApplicationDecorator }

  it "should respond_to decorates" do
    expect do
      subject.decorates :good_balance, class: Good::Balance
    end.to_not raise_error
  end

  it "should respond_to allows" do
    expect do
      subject.allows :description, :quantity
    end.to_not raise_error
  end
end
